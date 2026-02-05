import 'package:flutter/material.dart';
import '../pages/start.dart';
import '../pages/signin.dart';
import '../pages/signup.dart';
import '../pages/home.dart';
import '../pages/createnewgroup.dart';
import '../pages/profile.dart';
import '../pages/addreview.dart';
import '../pages/marketplace.dart';

class AppRoutes {
  static const start = '/';
  static const signin = '/signin';
  static const signup = '/signup';
  static const home = '/home';
  static const creategroup = '/creategroup';
  static const profile = '/profile';
  static const addreview = '/addreview';
  static const marketplace = '/marketplace';

  static final routes = <String, WidgetBuilder>{
    start: (_) => const StartPage(),
    signin: (_) => const SigninPage(),
    signup: (_) => const SignupPage(),
    home: (_) => const HomePage(),
    creategroup: (_) => const CreateNewGroupPage(),
    profile: (_) => const ProfilePage(),
    addreview: (_) => const AddReviewPage(subscription: {}),
    marketplace: (_) => const MarketplacePage(),
  };
}
