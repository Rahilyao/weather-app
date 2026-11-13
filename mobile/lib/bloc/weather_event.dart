part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

/// Пользователь ввёл город и нажал поиск.
final class WeatherRequested extends WeatherEvent {
  const WeatherRequested(this.city);
  final String city;

  @override
  List<Object?> get props => [city];
}

/// Пользователь нажал кнопку обновления.
final class WeatherRefreshed extends WeatherEvent {
  const WeatherRefreshed();
}
