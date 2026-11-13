const { describe } = require('./weatherCodes');

const GEO_URL = 'https://geocoding-api.open-meteo.com/v1/search';
const FORECAST_URL = 'https://api.open-meteo.com/v1/forecast';
const CACHE_TTL_MS = 10 * 60 * 1000; // 10 минут

const cache = new Map();

class HttpError extends Error {
  constructor(status, message) {
    super(message);
    this.status = status;
  }
}

async function getJson(url) {
  let response;
  try {
    response = await fetch(url, { signal: AbortSignal.timeout(10000) });
  } catch (e) {
    throw new HttpError(502, 'Сервис погоды недоступен. Попробуйте позже.');
  }
  if (!response.ok) {
    throw new HttpError(502, 'Сервис погоды вернул ошибку.');
  }
  return response.json();
}

async function findCity(city) {
  const url = `${GEO_URL}?name=${encodeURIComponent(city)}&count=1&language=ru`;
  const data = await getJson(url);
  if (!data.results || data.results.length === 0) {
    throw new HttpError(404, `Город «${city}» не найден.`);
  }
  return data.results[0];
}

async function getWeather(city) {
  const key = city.trim().toLowerCase();
  const cached = cache.get(key);
  if (cached && Date.now() - cached.time < CACHE_TTL_MS) {
    return cached.value;
  }

  const place = await findCity(city.trim());

  const params = new URLSearchParams({
    latitude: String(place.latitude),
    longitude: String(place.longitude),
    current:
      'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
    daily: 'weather_code,temperature_2m_max,temperature_2m_min',
    timezone: 'auto',
    forecast_days: '7',
  });
  const data = await getJson(`${FORECAST_URL}?${params.toString()}`);

  const daily = data.daily.time.map((date, i) => ({
    date,
    tempMax: data.daily.temperature_2m_max[i],
    tempMin: data.daily.temperature_2m_min[i],
    weatherCode: data.daily.weather_code[i],
    description: describe(data.daily.weather_code[i]),
  }));

  const value = {
    city: place.name,
    country: place.country || '',
    latitude: place.latitude,
    longitude: place.longitude,
    current: {
      temperature: data.current.temperature_2m,
      feelsLike: data.current.apparent_temperature,
      humidity: data.current.relative_humidity_2m,
      windSpeed: data.current.wind_speed_10m,
      weatherCode: data.current.weather_code,
      description: describe(data.current.weather_code),
    },
    daily,
  };

  cache.set(key, { time: Date.now(), value });
  return value;
}

function clearCache() {
  cache.clear();
}

module.exports = { getWeather, clearCache, HttpError };
