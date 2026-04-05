import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:9000';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:9000';
    }
    return 'http://localhost:9000';
  }

  static const String userProfile = '/api/user';
  static const String goal = '/api/goal';
  static const String expenses = '/api/expenses';
  static const String dashboard = '/api/dashboard';
  static const String insights = '/api/dashboard';
}
