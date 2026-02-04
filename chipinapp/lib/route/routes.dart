import 'package:flutter/material.dart';
import '../pages/start.dart';
import '../pages/signin.dart';
import '../pages/signup.dart';
import '../pages/home.dart';
import '../pages/createnewgroup.dart';
// import '../pages/groupdetails.dart'; // ไม่ต้อง import ก็ได้ถ้าไม่ได้ใช้ใน map นี้

class AppRoutes {
  static const start = '/';
  static const signin = '/signin';
  static const signup = '/signup';
  static const home = '/home';
  static const creategroup = '/creategroup';
  // static const details = '/details'; // ลบ หรือ ไม่ต้องมีบรรทัดนี้

  static final routes = <String, WidgetBuilder>{
    start: (_) => const StartPage(),
    signin: (_) => const SigninPage(),
    signup: (_) => const SignupPage(),
    home: (_) => const HomePage(),
    creategroup: (_) => const CreateNewGroupPage(),
    // details: (_) => const GroupDetailsPage(), // ลบทิ้ง เพราะหน้านี้ต้องรับค่า subscription
  };
}