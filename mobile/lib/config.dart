class AppConfig {
  /// Адрес сервера.
  /// 10.0.2.2 - это специальный адрес, по которому Android-эмулятор
  /// видит ваш компьютер (там в Docker работает сервер на порту 3000).
  static const String baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:3000');
}
