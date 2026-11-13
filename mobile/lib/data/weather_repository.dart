import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/weather.dart';

class WeatherException implements Exception {
  const WeatherException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Репозиторий - единственное место, где приложение общается с сервером.
class WeatherRepository {
  WeatherRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/api/weather')
        .replace(queryParameters: {'city': city});

    try {
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 15));
      final body = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        return Weather.fromJson(body as Map<String, dynamic>);
      }
      final message = (body is Map<String, dynamic> ? body['error'] : null) as String?;
      throw WeatherException(message ?? 'Ошибка сервера (${response.statusCode})');
    } on WeatherException {
      rethrow;
    } on TimeoutException {
      throw const WeatherException('Сервер не отвечает. Проверьте, что он запущен.');
    } on SocketException {
      throw const WeatherException('Нет связи с сервером. Запущен ли Docker-контейнер?');
    } on http.ClientException {
      throw const WeatherException('Нет связи с сервером. Запущен ли Docker-контейнер?');
    } on FormatException {
      throw const WeatherException('Сервер вернул непонятный ответ.');
    }
  }
}
