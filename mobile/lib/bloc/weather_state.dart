part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

final class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

final class WeatherLoaded extends WeatherState {
  const WeatherLoaded(this.weather);
  final Weather weather;

  @override
  List<Object?> get props => [weather];
}

final class WeatherFailure extends WeatherState {
  const WeatherFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
