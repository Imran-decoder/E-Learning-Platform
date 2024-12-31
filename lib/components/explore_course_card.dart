import 'package:flutter/material.dart';

class ExploreCourseCard extends StatelessWidget {
  final String logoPath;
  final String courseName;

  const ExploreCourseCard({
    required this.logoPath,
    required this.courseName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white24,
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
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
