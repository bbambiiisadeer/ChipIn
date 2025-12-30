import 'package:flutter/material.dart';
import '../pages/home.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 104.0,
          bottom: 48.0,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(
                    "assets/images/logoblack.png",
                    height: 40.0,
                  ),
                ),
              ),
              const SizedBox(height: 82.0),
              const Text(
                "Create your account",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 35.0),
              TextField(
                decoration: InputDecoration(
                  hintText: "Username",
                  hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: const Color.fromARGB(255, 92, 94, 98),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 242, 242, 242),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(15.0),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                style: TextStyle(fontSize: 14.0, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: const Color.fromARGB(255, 92, 94, 98),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 242, 242, 242),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(15.0),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                style: TextStyle(fontSize: 14.0, color: Colors.black),
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: const Color.fromARGB(255, 92, 94, 98),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 242, 242, 242),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(15.0),
                  suffixIcon: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color.fromARGB(255, 92, 94, 98),
                      size: 24.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 35.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: Container(
                  height: 47.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  "- Or  sign in with -",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 92, 94, 98),
                  ),
                ),
              ),
              const SizedBox(height: 17.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 30.0,
                children: [
                  Container(
                    height: 46.0,
                    width: 46.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0),
                    ),
                    child: Image.asset(
                      "assets/images/googlelogo.png",
                      height: 24.0,
                    ),
                  ),
                  Container(
                    height: 46.0,
                    width: 46.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0),
                    ),
                    child: Image.asset(
                      "assets/images/facebooklogo.png",
                      height: 24.0,
                    ),
                  ),
                  Container(
                    height: 46.0,
                    width: 46.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0),
                    ),
                    child: Image.asset(
                      "assets/images/spotifylogo.png",
                      height: 24.0,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                spacing: 10.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Text(
                    "into existing account",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 92, 94, 98),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
