import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning/components/Admin/edit_chapter.dart';

class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({super.key});

  @override
  _EditCourseScreenState createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final TextEditingController _courseTitleController = TextEditingController();
  String? courseId; // Store course ID to pass to EditChapterComponent
  String? fetchedCourseTitle; // Store course title for editing
  Map<String, Map<String, dynamic>> chaptersData = {}; // Store tasks data
  bool isLoading = false;

  // Fetch course and tasks data
  void _fetchCourse(String courseTitle) async {
    setState(() {
      isLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Courses')
          .where('title', isEqualTo: courseTitle.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var courseDoc = querySnapshot.docs.first;

        final tasksSnapshot = await FirebaseFirestore.instance
            .collection('Courses')
            .doc(courseDoc.id)
            .collection('tasks')
            .get();

        setState(() {
          courseId = courseDoc.id;
          fetchedCourseTitle = courseDoc['title'];
          chaptersData = {
            for (var doc in tasksSnapshot.docs)
              doc.id: {
                'description': doc['description'],
                'number': doc['number'],
                'video': doc['video'],
              },
          };
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No course found with that title.')),
        );
      }
    } catch (e) {
      print("Error fetching course: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch course data.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Course",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _courseTitleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Course Title",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _fetchCourse(_courseTitleController.text);
                  },
                  child: const Text(
                    "Fetch Chapters",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (courseId != null && fetchedCourseTitle != null)
                Expanded(
                  child: EditChapterComponent(
                    courseId: courseId!,
                    initialCourseTitle: fetchedCourseTitle!,
                    chaptersData: chaptersData,
                    onSave: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Course updated successfully!')),
                      );
                    },
                  ),
                ),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
