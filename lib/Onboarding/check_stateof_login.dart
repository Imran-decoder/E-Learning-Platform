// import 'package:elearning/Onboarding/splash.dart';
import 'package:flutter/material.dart';
// import 'package:elearning/Onboarding/sign-in.dart';
// import 'package:elearning/Onboarding/sign-in.dart'; // Ensure this import points to the correct file where SignInScreen is defined


class SigninOrSignupScreen extends StatelessWidget {
  const SigninOrSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing the screen width using MediaQuery in the build method
    double screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate button width based on screen width for all buttons
    double buttonWidth = screenWidth > 600 ? 550 : 300;  // Larger button width for desktops
    double buttonHeight = 48;  // Default button height
    
    // If the screen width is large (e.g., desktop), make the button height a bit bigger
    if (screenWidth > 1200) {  // Consider it a desktop if the width is larger than 1200px
      buttonHeight = 50;  // Increase height for desktop view
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(  // Center the entire column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center,  // Center horizontally
              children: [
                Image.asset('assets/images/splash.png', height: 146),
                const SizedBox(height: 16.0),  // Space between image and buttons

                // Button for "Log In"
                Container(
                  alignment: Alignment.center,  // Ensure the button is centered horizontally
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      minimumSize: Size(buttonWidth, buttonHeight),  // Responsive width and height
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Log In"),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Button for "Sign Up"
                Container(
                  alignment: Alignment.center,  // Ensure the button is centered horizontally
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      minimumSize: Size(buttonWidth, buttonHeight),  // Responsive width and height
                      shape: const StadiumBorder(),
                      backgroundColor: const Color(0xFFFE9901),
                    ),
                    child: const Text("Sign Up"),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Button for "Skip"
                // Container(
                //   alignment: Alignment.center,  // Ensure the button is centered horizontally
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.pushNamed(context, '/dashboard');
                //     },
                //     style: ElevatedButton.styleFrom(
                //       elevation: 0,
                //       foregroundColor: Colors.white,
                //       minimumSize: Size(buttonWidth, buttonHeight),  // Responsive width and height
                //       shape: const StadiumBorder(),
                //       backgroundColor: const Color(0xFFFE9901),
                //     ),
                //     child: const Text("Skip"),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}