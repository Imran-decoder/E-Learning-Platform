import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteCourseScreen extends StatefulWidget {
  const DeleteCourseScreen({super.key});

  @override
  _DeleteCourseScreenState createState() => _DeleteCourseScreenState();
}

class _DeleteCourseScreenState extends State<DeleteCourseScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;

  Future<void> _deleteCourse() async {
    String courseTitle = _titleController.text.trim();
    if (courseTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a course title.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('Courses')
          .where('title', isEqualTo: courseTitle)
          .get();

      if (query.docs.isNotEmpty) {
        for (var doc in query.docs) {
          await doc.reference.delete();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Course deleted successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Course not found.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Course'),
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Course Title",
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _deleteCourse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Delete Course", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
