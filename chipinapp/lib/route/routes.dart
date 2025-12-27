import 'package:flutter/material.dart';
import '../pages/start.dart';

class AppRoutes {
  static const start = '/';
  // static const dashboard = '/dashboard';
  // static const upload = '/upload';
  // static const login = '/login';

  static final routes = <String, WidgetBuilder>{
    start: (_) => const startPage(),
    // dashboard: (_) => const DashboardPage(),
    // upload: (_) => const UploadPage(),
    // login: (_) => const LoginPage(),
  };
}
