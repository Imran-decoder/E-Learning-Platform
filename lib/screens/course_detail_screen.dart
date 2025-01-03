import 'package:flutter/material.dart';
import 'detail_info_screen.dart';
import 'package:elearning/components/header_section.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String courseName;

  const CourseDetailsScreen({
    required this.courseName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName),
        backgroundColor: Colors.deepOrange,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reusable Tappable Header Sections
              HeaderSection(
                title: "Course Overview",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedInfoScreen(
                        title: "Course Overview",
                        content: "This course covers all the fundamentals of the topic with practical examples and hands-on exercises to help you master the concepts.",
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              HeaderSection(
                title: "Course Content",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedInfoScreen(
                        title: "Course Content",
                        content: "1. Introduction to Basics\n2. Intermediate Concepts\n3. Advanced Topics\n4. Final Project and Practice",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
