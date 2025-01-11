import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  Future<void> _navigateToNextScreen() async {
    var user = FirebaseAuth.instance.currentUser;

    // Adding a delay to show the splash screen for a moment.
    await Future.delayed(const Duration(seconds: 3));

    if (user != null) {
      // User is logged in
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // User is not logged in
      Navigator.pushReplacementNamed(context, '/log-sign');
    }
  }

  @override
  void dispose() {
    // Restore system UI overlays when this screen is disposed
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash.png'),
            const SizedBox(height: 20),
            const Text(
              'THE FIRE VALA',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
