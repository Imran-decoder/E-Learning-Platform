import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_course_screen.dart';
import 'edit_course_screen.dart';

class ManageCourseScreen extends StatelessWidget {
  const ManageCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Courses'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.black87,
        elevation: 4,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCardButton(
                    context,
                    icon: Icons.add_circle_outline,
                    label: "Create New Course",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddCourseScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCardButton(
                    context,
                    icon: Icons.edit_outlined,
                    label: "Edit Courses",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditCourseScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCardButton(
                    context,
                    icon: Icons.delete_outline,
                    label: "Delete Course",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DeleteCourseScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A1A1A),
        padding: const EdgeInsets.symmetric(vertical: 20),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        shadowColor: Colors.black54,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 22),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
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
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
              child:
                  const Text("Delete Course", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
