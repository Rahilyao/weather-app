const test = require('node:test');
const assert = require('node:assert');
const app = require('./app');
const { clearCache } = require('./weatherService');

function fakeFetch(url) {
  const u = String(url);
  if (u.includes('geocoding-api')) {
    const empty = u.includes('Nowhere');
    return Promise.resolve({
      ok: true,
      json: async () =>
        empty
          ? {}
          : { results: [{ name: 'Бишкек', country: 'Кыргызстан', latitude: 42.87, longitude: 74.59 }] },
    });
  }
  return Promise.resolve({
    ok: true,
    json: async () => ({
      current: { temperature_2m: 12.3, apparent_temperature: 10.1, relative_humidity_2m: 55, weather_code: 2, wind_speed_10m: 7.5 },
      daily: {
        time: ['2026-11-13', '2026-11-14'],
        temperature_2m_max: [14, 15],
        temperature_2m_min: [3, 4],
        weather_code: [2, 61],
      },
    }),
  });
}

test('API works with mocked Open-Meteo', async () => {
  const original = globalThis.fetch;
  const server = app.listen(0);
  const port = server.address().port;
  clearCache();
  try {
    let r = await original(`http://127.0.0.1:${port}/health`);
    assert.strictEqual(r.status, 200);

    globalThis.fetch = (url, opts) =>
      String(url).includes('127.0.0.1') ? original(url, opts) : fakeFetch(url);

    r = await fetch(`http://127.0.0.1:${port}/api/weather?city=Bishkek`);
    assert.strictEqual(r.status, 200);
    const body = await r.json();
    assert.strictEqual(body.city, 'Бишкек');
    assert.strictEqual(body.current.description, 'Переменная облачность');
    assert.strictEqual(body.daily.length, 2);
    assert.strictEqual(body.daily[1].description, 'Небольшой дождь');

    r = await fetch(`http://127.0.0.1:${port}/api/weather`);
    assert.strictEqual(r.status, 400);

    r = await fetch(`http://127.0.0.1:${port}/api/weather?city=Nowhere`);
    assert.strictEqual(r.status, 404);
  } finally {
    globalThis.fetch = original;
    server.close();
  }
});
