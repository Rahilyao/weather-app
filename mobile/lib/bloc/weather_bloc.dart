import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/weather_repository.dart';
import '../models/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(this._repository) : super(const WeatherInitial()) {
    on<WeatherRequested>(_onRequested);
    on<WeatherRefreshed>(_onRefreshed);
  }

  final WeatherRepository _repository;
  String? _lastCity;

  Future<void> _onRequested(
    WeatherRequested event,
    Emitter<WeatherState> emit,
  ) async {
    final city = event.city.trim();
    if (city.isEmpty) {
      emit(const WeatherFailure('Введите название города.'));
      return;
    }
    _lastCity = city;
    await _load(city, emit);
  }

  Future<void> _onRefreshed(
    WeatherRefreshed event,
    Emitter<WeatherState> emit,
  ) async {
    final city = _lastCity;
    if (city == null) return;
    await _load(city, emit);
  }

  Future<void> _load(String city, Emitter<WeatherState> emit) async {
    emit(const WeatherLoading());
    try {
      final weather = await _repository.fetchWeather(city);
      emit(WeatherLoaded(weather));
    } on WeatherException catch (e) {
      emit(WeatherFailure(e.message));
    } catch (_) {
      emit(const WeatherFailure('Что-то пошло не так. Попробуйте ещё раз.'));
    }
  }
}
