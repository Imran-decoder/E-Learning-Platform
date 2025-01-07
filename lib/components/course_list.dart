import 'package:flutter/material.dart';
import 'package:elearning/components/explore_course_card.dart';

class CourseList extends StatelessWidget {
  final List<Map<String, String>> courses;
  final Function(Map<String, String>) onCourseTap;

  const CourseList({
    super.key,
    required this.courses,
    required this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return ExploreCourseCard(
            logoPath: course['logo']!,
            courseName: course['name']!,
            onTap: () => onCourseTap(course),
          );
        },
      ),
    );
  }
}
