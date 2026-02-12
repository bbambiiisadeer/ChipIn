import 'package:flutter/material.dart';
import '../pages/signup.dart';
import '../pages/home.dart';

import '../services/auth_service.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key, this.fromSignup = false});

  final bool fromSignup;

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // สร้าง Controller สำหรับช่องกรอกข้อมูล
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // สร้าง Instance ของ AuthService
  final AuthService _authService = AuthService();

  // เพิ่มตัวแปรเช็คสถานะ Loading (เพื่อความสวยงามตอนกดปุ่ม)
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose(); // ล้าง Controller
    _passwordController.dispose(); // ล้าง Controller
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    // เรียกใช้ Login จาก Service
    String? result = await _authService.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);

      if (result == null) {
        // Login สำเร็จ ไปหน้า Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Login ไม่สำเร็จ แสดงแจ้งเตือน Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    // เรียกใช้ฟังก์ชันจาก AuthService ที่เราเพิ่ม SHA-1 และ Config ไว้แล้ว
    final result = await _authService.signInWithGoogle();

    if (mounted) {
      setState(() => _isLoading = false);

      if (result != null) {
        // Login สำเร็จ ไปหน้า Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // ถ้า result เป็น null แสดงว่าผู้ใช้ยกเลิกหรือมี Error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Google Sign-in failed or cancelled"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleFacebookSignIn() async {
  setState(() => _isLoading = true);

  // เรียกใช้ฟังก์ชันจาก AuthService
  final result = await _authService.signInWithFacebook();

  if (mounted) {
    setState(() => _isLoading = false);

    if (result != null) {
      // ถ้าสำเร็จ ไปหน้า Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // ถ้าพลาดหรือยกเลิก แสดงแจ้งเตือน
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Facebook Sign-in failed or cancelled"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

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
                    width: 40.0,
                  ),
                ),
              ),
              const SizedBox(height: 82.0),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sign in to your account",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 35.0),
                    TextField(
                      controller: _emailController,
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
                      controller: _passwordController,
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
                      onTap: _isLoading
                          ? null
                          : _handleLogin, // ถ้ากำลัง Load อยู่จะกดไม่ได้
                      child: Container(
                        height: 47.0,
                        decoration: BoxDecoration(
                          color: _isLoading
                              ? Colors.grey
                              : Colors.black, // เปลี่ยนสีตอน Load
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                ) // แสดงวงกลมหมุนๆ
                              : const Text(
                                  "Sign in",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
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
                        // ค้นหา Container ที่ใส่รูป googlelogo.png แล้วแก้เป็นแบบนี้ครับ:
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : _handleGoogleSignIn, // ป้องกันการกดซ้อนตอนโหลด
                          child: Container(
                            height: 46.0,
                            width: 46.0,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(width: 1.0),
                            ),
                            child: _isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : Image.asset(
                                    "assets/images/googlelogo.png",
                                    height: 24.0,
                                  ),
                          ),
                        ),
                        // ค้นหา Container ที่ใส่รูป facebooklogo.png และแก้เป็น:
GestureDetector(
  onTap: _isLoading ? null : _handleFacebookSignIn,
  child: Container(
    height: 46.0,
    width: 46.0,
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(width: 1.0),
    ),
    child: _isLoading 
      ? const Padding(
          padding: EdgeInsets.all(12.0),
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
        )
      : Image.asset(
          "assets/images/facebooklogo.png",
          height: 24.0,
        ),
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
                  ],
                ),
              ),
              const Spacer(),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Row(
                  spacing: 10.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have any account?",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 92, 94, 98),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const SignupPage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
