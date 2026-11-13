const express = require('express');
const cors = require('cors');
const { getWeather, HttpError } = require('./weatherService');

const app = express();
app.use(cors());

// Проверка, что сервер жив
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// GET /api/weather?city=Bishkek
app.get('/api/weather', async (req, res) => {
  const city = (req.query.city || '').toString().trim();
  if (!city) {
    return res.status(400).json({ error: 'Укажите город: ?city=Bishkek' });
  }
  try {
    const weather = await getWeather(city);
    res.json(weather);
  } catch (e) {
    if (e instanceof HttpError) {
      return res.status(e.status).json({ error: e.message });
    }
    console.error(e);
    res.status(500).json({ error: 'Внутренняя ошибка сервера.' });
  }
});

module.exports = app;
