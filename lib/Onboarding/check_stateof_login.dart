// import 'package:elearning/Onboarding/splash.dart';
import 'package:flutter/material.dart';
// import 'package:elearning/Onboarding/sign-in.dart';
// import 'package:elearning/Onboarding/sign-in.dart'; // Ensure this import points to the correct file where SignInScreen is defined


class SigninOrSignupScreen extends StatelessWidget {
  const SigninOrSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset('assets/images/splash.png',height: 146),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,'/login'
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF00BF6D),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const StadiumBorder(),
                ),
                child: const Text("Log In"),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,'/signup'
                  );
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                    backgroundColor: const Color(0xFFFE9901)),
                child: const Text("Sign Up"),
              ),
              const Spacer(flex: 2),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,'/dashboard'
                  );
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                    backgroundColor: const Color(0xFFFE9901)),
                child: const Text("Skip"),
              ),
              const Spacer(flex: 2),
            ],
            
          ),
        ),
      ),
    );
  }
}
