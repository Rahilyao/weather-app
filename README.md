# Weather App

Мобильное приложение погоды: Flutter + Bloc, сервер на Node.js (Express) в Docker.

## Возможности

- Поиск погоды по названию города
- Текущая температура, ощущаемая температура, влажность, ветер
- Прогноз на 7 дней
- Обработка ошибок (город не найден, нет связи с сервером)

## Архитектура

Мобильное приложение (Flutter, Bloc) -> HTTP -> Сервер (Node.js, Docker) -> Open-Meteo API

- `mobile/` - Flutter-приложение. State management: Bloc (`lib/bloc`), общение с сервером: `lib/data`, экран: `lib/ui`.
- `server/` - REST API. Эндпоинты: `GET /health` и `GET /api/weather?city=Bishkek`.
- `docker-compose.yml` - запуск сервера в Docker.

## Запуск

### 1. Сервер (нужен Docker Desktop)

    docker compose up --build -d
    curl.exe "http://localhost:3000/api/weather?city=Bishkek"

### 2. Мобильное приложение

Запустить Android-эмулятор, затем:

    cd mobile
    flutter pub get
    flutter run

Эмулятор видит компьютер по адресу `10.0.2.2` (настроено в `mobile/lib/config.dart`).

## Тесты сервера

    cd server
    npm install
    npm test

## Стек

Flutter, flutter_bloc, equatable, http, Node.js, Express, Docker, Open-Meteo API.