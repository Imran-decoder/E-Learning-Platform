import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_course_screen.dart';
import 'edit_course_screen.dart';

class ManageCourseScreen extends StatelessWidget {
  const ManageCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Courses'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              _buildCustomButton(
                context,
                "Create New Course",
                [Colors.green, Colors.greenAccent],
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddCourseScreen()),
                  );
                },
              ),

              const SizedBox(height: 20),

              _buildCustomButton(
                context,
                "Edit Courses",
                [Colors.red, Colors.redAccent],
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditCourseScreen()),
                  );
                },
              ),

              const SizedBox(height: 20),

              _buildCustomButton(
                context,
                "Delete Course",
                [Colors.blue, Colors.lightBlueAccent],
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DeleteCourseScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(
      BuildContext context,
      String label,
      List<Color> gradientColors,
      VoidCallback onPressed,
      ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30.0),
      splashColor: gradientColors[0].withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
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

class DeleteCourseScreen extends StatefulWidget {
  const DeleteCourseScreen({super.key});

  @override
  _DeleteCourseScreenState createState() => _DeleteCourseScreenState();
}

class _DeleteCourseScreenState extends State<DeleteCourseScreen> {
  final TextEditingController _courseTitleController = TextEditingController();

  Future<void> _deleteCourse() async {
    String title = _courseTitleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a course title.')),
      );
      return;
    }

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Courses')
          .where('title', isEqualTo: title)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No course found with title: $title')),
        );
        return;
      }

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course "$title" deleted successfully.')),
      );
      _courseTitleController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting course: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Course'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Course Title to Delete:",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _courseTitleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Course Title",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteCourse,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
              child: const Text("Delete Course", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
