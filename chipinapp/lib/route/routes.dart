import 'package:flutter/material.dart';
import '../pages/start.dart';
import '../pages/signin.dart';
import '../pages/signup.dart';
import '../pages/home.dart';
import '../pages/createnewgroup.dart';

class AppRoutes {
  static const start = '/';
  static const signin = '/signin';
  static const signup = '/signup';
  static const home = '/home';
  static const creategroup = '/creategroup';
  // static const upload = '/upload';
  // static const login = '/login';

  static final routes = <String, WidgetBuilder>{
    start: (_) => const StartPage(),
    signin: (_) => const SigninPage(),
    signup: (_) => const SignupPage(),
    home: (_) => const HomePage(),
    creategroup: (_) => const CreateNewGroupPage(),
    // upload: (_) => const UploadPage(),
    // login: (_) => const LoginPage(),
  };
}
