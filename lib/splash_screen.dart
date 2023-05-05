import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>
    with SingleTickerProviderStateMixin {
  BuildContext? _context;
  @override
  void initState() {
    super.initState();
    _context = context;
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacementNamed(
      _context!,
      '/home',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Transform.scale(
                scale: 1.1,
                child: Lottie.network(
                  'https://assets9.lottiefiles.com/packages/lf20_tqagefcc.json',
                  repeat: true,
                  height: 300,
                  width: 300,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const AnimatedText(),
          ],
        ),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  const AnimatedText({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..forward();
    _animation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<Offset>(
                begin: const Offset(0, 0.9), end: const Offset(0, 0.0))
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
                begin: const Offset(0, 0.0), end: const Offset(0, -0.1))
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween:
            Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0.0))
                .chain(CurveTween(curve: Curves.easeInCirc)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
                begin: const Offset(0, 0.0), end: const Offset(0, -0.05))
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
                begin: const Offset(0, -0.05), end: const Offset(0, 0.0))
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _animation,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Healthy',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0)),
            SizedBox(width: 10.0),
            Text('Food',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 25.0))
          ],
        ));
  }
}
