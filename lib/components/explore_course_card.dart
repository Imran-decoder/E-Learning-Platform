import 'package:flutter/material.dart';

class ExploreCourseCard extends StatelessWidget {
  final String logoPath;
  final String courseName;
  final VoidCallback onTap;

  const ExploreCourseCard({
    required this.logoPath,
    required this.courseName,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logoPath,
                height: 60,
                width: 60,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10),
              Text(
                courseName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
