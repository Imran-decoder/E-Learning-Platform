import 'package:flutter/material.dart';
import 'add_course_screen.dart';
import 'edit_course_screen.dart';

class ManageCourseScreen extends StatelessWidget {
  const ManageCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Courses'),
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),  // Space from top

              // Create New Course Button
              _buildCustomButton(
                context,
                "Create New Course",
                Colors.green,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddCourseScreen()),
                  );
                },
              ),

              const SizedBox(height: 20),  // Space between buttons

              // Edit Courses Button
              _buildCustomButton(
                context,
                "Edit Courses",
                Colors.red,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditCourseScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable custom button widget
  Widget _buildCustomButton(
      BuildContext context,
      String label,
      Color color,
      VoidCallback onPressed,
      ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20.0),
      splashColor: color.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        width: MediaQuery.of(context).size.width - 32,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
