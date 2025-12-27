import 'package:chipinapp/pages/signin.dart';
import 'package:flutter/material.dart';
import '../pages/start.dart';

class AppRoutes {
  static const start = '/';
  static const signin = '/signin';
  // static const upload = '/upload';
  // static const login = '/login';

  static final routes = <String, WidgetBuilder>{
    start: (_) => const StartPage(),
    signin: (_) => const SigninPage(),
    // upload: (_) => const UploadPage(),
    // login: (_) => const LoginPage(),
  };
}
