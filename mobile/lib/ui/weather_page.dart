import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/weather_bloc.dart';
import '../models/weather.dart';
import 'weather_icons.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _controller = TextEditingController(text: 'Bishkek');

  @override
  void initState() {
    super.initState();
    // Сразу при открытии просим погоду для города по умолчанию.
    context.read<WeatherBloc>().add(WeatherRequested(_controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    context.read<WeatherBloc>().add(WeatherRequested(_controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода'),
        actions: [
          IconButton(
            tooltip: 'Обновить',
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<WeatherBloc>().add(const WeatherRefreshed()),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  labelText: 'Город',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _search,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    return switch (state) {
                      WeatherInitial() =>
                        const Center(child: Text('Введите город')),
                      WeatherLoading() =>
                        const Center(child: CircularProgressIndicator()),
                      WeatherFailure(:final message) => _ErrorView(message),
                      WeatherLoaded(:final weather) => _WeatherView(weather),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _WeatherView extends StatelessWidget {
  const _WeatherView(this.weather);
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final theme = Theme.of(context);

    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  weather.country.isEmpty
                      ? weather.city
                      : '${weather.city}, ${weather.country}',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Icon(iconForCode(current.weatherCode),
                    size: 80, color: theme.colorScheme.primary),
                Text(
                  '${current.temperature.round()}°C',
                  style: theme.textTheme.displayMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(current.description, style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Detail(Icons.thermostat,
                        'Ощущается', '${current.feelsLike.round()}°'),
                    _Detail(Icons.water_drop, 'Влажность', '${current.humidity}%'),
                    _Detail(Icons.air, 'Ветер',
                        '${current.windSpeed.round()} км/ч'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Прогноз на 7 дней', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final day in weather.daily) _DayTile(day),
      ],
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile(this.day);
  final DailyForecast day;

  @override
  Widget build(BuildContext context) {
    final name = weekdayNames[day.date.weekday - 1];
    return Card(
      child: ListTile(
        leading: Icon(iconForCode(day.weatherCode)),
        title: Text('$name, ${day.date.day.toString().padLeft(2, '0')}.'
            '${day.date.month.toString().padLeft(2, '0')}'),
        subtitle: Text(day.description),
        trailing: Text(
          '${day.tempMax.round()}° / ${day.tempMin.round()}°',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
