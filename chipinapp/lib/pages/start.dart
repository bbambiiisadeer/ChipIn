import 'package:flutter/material.dart';
import '../pages/signin.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
  late AnimationController _textFadeController;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _textFadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _textFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeOut),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _textFadeController.forward();
        
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SigninPage(),
            transitionDuration: const Duration(milliseconds: 1000),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
                  .animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
                    ),
                  );

              return FadeTransition(opacity: fadeAnimation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16.0,
          children: [
            Hero(
              tag: 'logo',
              flightShuttleBuilder:
                  (
                    flightContext,
                    animation,
                    direction,
                    fromContext,
                    toContext,
                  ) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        final size = 60.0;

                        final color = ColorTween(
                          begin: Colors.white,
                          end: Colors.black,
                        ).evaluate(animation);

                        return ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            color ?? Colors.white,
                            BlendMode.srcATop,
                          ),
                          child: Image.asset(
                            "assets/images/logowhite.png",
                            height: size,
                            width: size,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    );
                  },
              child: Image.asset(
                "assets/images/logowhite.png",
                height: 60.0,
                width: 60.0,
              ),
            ),
            FadeTransition(
              opacity: _textFadeAnimation,
              child: const Text(
                "ChipIn",
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}