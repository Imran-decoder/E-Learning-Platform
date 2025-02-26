import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About",
        style: TextStyle(fontWeight: FontWeight.bold,
        color: Colors.white),),
        backgroundColor: Colors.deepOrangeAccent,
              ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start (left)
            children: <Widget>[
              const SizedBox(height: 20),
              // Splash image centered at the top
              FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: Image.asset(
                    'assets/images/about.png', // Path to your splash image
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain, // Ensures the full image is visible without distortion
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Heading with animation - The Fire Wala
              FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30), // Capsule shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.3),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Text(
                      'The Fire Wala',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Paragraph content for "The Fire Wala"
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'The Fire Wala Safety Services is a full-service fire safety provider focused on providing comprehensive solutions for commercial and residential customers.\n\n'
                  'We offer a complete range of fire safety solutions, including fire extinguishers, fire alarms, smoke detectors, fire hydrants & automatic sprinkler systems, and fire suppression systems. We also provide fire safety training and education to help you understand the importance of fire safety in the workplace and at home. Our experienced technicians are certified to install and maintain all types of fire safety equipment and systems.\n\n'
                  'Our fire safety services are tailored to meet the specific requirements of each customer. We take the time to understand your unique needs and develop a plan that meets them. We also offer comprehensive fire safety plans that can help you protect your property and personnel. Our experienced staff is on call 24 hours a day to respond to any fire safety emergency.\n\n'
                  'We also offer a wide range of fire safety products, including fire extinguishers, fire suppression systems, fire alarms, and smoke detectors. We also offer a variety of fire safety signs and labels to help you identify potential fire hazards in your facility.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // "The App" section with animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30), // Capsule shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.3),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Text(
                      'The App',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // App description
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  '"The Fire Wala" App, is your go-to platform for learning fire safety through interactive courses. Whether you\'re new to fire safety or looking to deepen your knowledge, our app provides a comprehensive and engaging learning experience.\n\n',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Key Features with animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Key Features:\n\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const TextSpan(
                          text: '• Structured Courses: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const TextSpan(
                          text: 'Learn fire safety through video lessons, study notes, and quizzes. Our courses cover both residential and commercial safety protocols.\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        const TextSpan(
                          text: '• Learning: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const TextSpan(
                          text: 'Watch videos, read notes, and test your knowledge with quizzes to ensure full comprehension of key concepts.\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        const TextSpan(
                          text: '• Progress Tracking: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const TextSpan(
                          text: 'Monitor your learning progress with an easy-to-use tracker that shows your course completion status and areas that need attention.\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        const TextSpan(
                          text: '• Gemini Chatbot: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const TextSpan(
                          text: 'Get instant answers to your questions with the intelligent Gemini Chatbot, available anytime to assist with general queries.\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        const TextSpan(
                          text: '• Admin Performance Tracking: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const TextSpan(
                          text: 'Admins can monitor user activity, track course completion, and assess performance to ensure effective learning.\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
