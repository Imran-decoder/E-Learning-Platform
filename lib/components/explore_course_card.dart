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
    Key? key,
  }) : super(key: key);

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
        padding: const EdgeInsets.only(right: 16.0, top: 10.0, bottom: 10.0), // Added margin to top and bottom
        child: Container(
          width: 160, // Adjusted size for a more spacious look
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: randomColors, // Use the lighter random color scheme
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Lighter shadow for a soft look
                spreadRadius: 2,
                blurRadius: 12,
                offset: Offset(0, 6),
              )
            ], // Soft shadow effect
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Adjusted alignment for better spacing
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image with top and bottom margin and left-right padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: Image.asset(
                    logoPath,
                    height: 100, // Image takes top area with a fixed height
                    width: double.infinity,
                    fit: BoxFit.cover, // Better image fitting
                  ),
                ),
              ),
              // Course name below the image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Text(
                  courseName,
                  style: TextStyle(
                    fontSize: 18, // Slightly smaller text for better spacing
                    fontWeight: FontWeight.w700, // Lighter weight for a more modern feel
                    color: Colors.black87, // Dark text for contrast
                    letterSpacing: 1.5, // Elegant letter spacing
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
