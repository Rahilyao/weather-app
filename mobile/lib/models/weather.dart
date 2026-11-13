import 'package:equatable/equatable.dart';

class CurrentWeather extends Equatable {
  const CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.description,
  });

  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final String description;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
      description: json['description'] as String,
    );
  }

  @override
  List<Object?> get props =>
      [temperature, feelsLike, humidity, windSpeed, weatherCode, description];
}

class DailyForecast extends Equatable {
  const DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
    required this.description,
  });

  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int weatherCode;
  final String description;

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.parse(json['date'] as String),
      tempMax: (json['tempMax'] as num).toDouble(),
      tempMin: (json['tempMin'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
      description: json['description'] as String,
    );
  }

  @override
  List<Object?> get props => [date, tempMax, tempMin, weatherCode, description];
}

class Weather extends Equatable {
  const Weather({
    required this.city,
    required this.country,
    required this.current,
    required this.daily,
  });

  final String city;
  final String country;
  final CurrentWeather current;
  final List<DailyForecast> daily;

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['city'] as String,
      country: (json['country'] as String?) ?? '',
      current: CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
      daily: (json['daily'] as List<dynamic>)
          .map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [city, country, current, daily];
}
