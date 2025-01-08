import 'package:flutter/material.dart';
import 'detail_info_screen.dart';
import 'package:elearning/components/header_section.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String courseName;
  final List<Map<String, String>> sections; // List of sections with title and content.

  const CourseDetailsScreen({
    required this.courseName,
    required this.sections,
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
          padding: const EdgeInsets.all(16.20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sections.map((section) {
              return Padding(padding: const EdgeInsets.only(bottom: 20.0),
              child: HeaderSection(
                title: section['title']!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedInfoScreen(
                        title: section['title']!,
                        content: section['content']!,
                      ),
                    ),
                  );
                },
              ),
             );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
