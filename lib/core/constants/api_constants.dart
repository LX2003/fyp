class ApiConstants {
  // For Android emulator use 10.0.2.2 instead of localhost
  // For physical device use your PC's IP e.g. 192.168.1.5
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String refresh = '/auth/refresh';
}