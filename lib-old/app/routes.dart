import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/booking/screens/home_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
    '/login': (context) => const LoginScreen(),
    // Define other routes here
  };
}
