import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  final String userName;

  const GreetingSection({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Hello, $userName!",
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
