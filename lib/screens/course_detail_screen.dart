import 'package:flutter/material.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String courseName;
  final String logoPath;

  const CourseDetailsScreen({
    required this.courseName,
    required this.logoPath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName), // Course name in AppBar title
        backgroundColor: Colors.deepOrange,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Logo with rounded rectangle background
            Positioned(
              top: 50,  // Adjust position for logo
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  logoPath,
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Course name below logo
          ],
        ),
      ),
    );
  }
}
