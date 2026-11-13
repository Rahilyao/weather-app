import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/weather_bloc.dart';
import 'data/weather_repository.dart';
import 'ui/weather_page.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => WeatherRepository(),
      child: BlocProvider(
        create: (context) => WeatherBloc(context.read<WeatherRepository>()),
        child: MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const WeatherPage(),
        ),
      ),
    );
  }
}
