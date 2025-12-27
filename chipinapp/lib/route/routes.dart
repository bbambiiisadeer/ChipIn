import 'package:flutter/material.dart';
import '../pages/start.dart';
import '../pages/signin.dart';
import '../pages/signup.dart';

class AppRoutes {
  static const start = '/';
  static const signin = '/signin';
  static const signup = '/signup';
  // static const upload = '/upload';
  // static const login = '/login';

  static final routes = <String, WidgetBuilder>{
    start: (_) => const StartPage(),
    signin: (_) => const SigninPage(),
    signup: (_) => const SignupPage(),
    // upload: (_) => const UploadPage(),
    // login: (_) => const LoginPage(),
  };
}
