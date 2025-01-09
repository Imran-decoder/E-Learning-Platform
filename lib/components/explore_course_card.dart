import 'dart:math';
import 'package:flutter/material.dart';

class ExploreCourseCard extends StatelessWidget {
  final String logoPath;
  final String courseName;
  final VoidCallback onTap;

  ExploreCourseCard({
    required this.logoPath,
    required this.courseName,
    required this.onTap,
    super.key,
  });

  // List of professional color schemes with lighter shades
  final List<List<Color>> _colorSchemes = [
    [Colors.blue.shade100, Colors.blue.shade400],
    [Colors.orange.shade100, Colors.orange.shade400],
    [Colors.green.shade100, Colors.green.shade400],
    [Colors.purple.shade100, Colors.purple.shade400],
    [Colors.red.shade100, Colors.red.shade400],
    [Colors.teal.shade100, Colors.teal.shade400],
  ];

  // Generate random color scheme
  List<Color> _getRandomColorScheme() {
    Random random = Random();
    return _colorSchemes[random.nextInt(_colorSchemes.length)];
  }

  @override
  Widget build(BuildContext context) {
    List<Color> randomColors = _getRandomColorScheme();

    return GestureDetector(
      onTap: onTap, // Handle tap
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, top: 10.0, bottom: 10.0),
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: randomColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Handle image loading
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    logoPath,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/default_logo.webp', // Fallback image
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              // Course name
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 6.0),
                child: Text(
                  courseName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: 0.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
