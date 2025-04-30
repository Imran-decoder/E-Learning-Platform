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
  final TextEditingController _googleFormController = TextEditingController();

  String? courseId;
  String? fetchedCourseTitle;
  String? fetchedGoogleForm;
  Map<String, Map<String, dynamic>> chaptersData = {};
  bool isLoading = false;
  String errorMessage = '';

  // Fetch course and chapters data
  Future<void> _fetchCourse(String courseTitle) async {
    if (courseTitle.trim().isEmpty) {
      setState(() {
        errorMessage = 'Course title cannot be empty';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = ''; // Reset previous errors
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

        final googleFormSnapshot = await FirebaseFirestore.instance
            .collection('Courses')
            .doc(courseDoc.id)
            .collection('googleForm')
            .get();

        setState(() {
          courseId = courseDoc.id;
          fetchedCourseTitle = courseDoc['title'];
          fetchedGoogleForm = googleFormSnapshot.docs.isNotEmpty
              ? googleFormSnapshot.docs.first.data()['url']
              : '';
          _googleFormController.text = fetchedGoogleForm ?? '';
          chaptersData = {
            for (var doc in tasksSnapshot.docs)
              doc.id: {
                'title': doc.data()['title'] ?? '',
                'description': doc.data().containsKey('description')
                    ? doc['description']
                    : '',
                'number': doc.data().containsKey('number') ? doc['number'] : 0,
                'video': doc.data().containsKey('video') ? doc['video'] : '',
                'document':
                    doc.data().containsKey('document') ? doc['document'] : '',
                'duration':
                    doc.data().containsKey('duration') ? doc['duration'] : '',
              },
          };
        });
      } else {
        setState(() {
          errorMessage = 'No course found with that title';
        });
      }
    } catch (e) {
      debugPrint("Error fetching course: $e");
      setState(() {
        errorMessage = 'Failed to fetch course data. Please try again.';
      });
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 800;

            return Padding(
              padding: isDesktop
                  ? const EdgeInsets.all(32.0)
                  : const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Edit Course",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Course Title Field
                  Card(
                    color: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: TextField(
                        controller: _courseTitleController,
                        onChanged: (value) {
                          setState(() {
                            errorMessage =
                                ''; // Reset error message while typing
                          });
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Course Title",
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: isDesktop ? 300 : 180,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 10),
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
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _courseTitleController.clear();
                            errorMessage = ''; // Clear any previous error
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  // Display error message if any
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  const SizedBox(height: 2),
                  // Google Form URL Field (only shown after fetching)
                  if (fetchedGoogleForm != null)
                    Card(
                      color: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextField(
                          controller: _googleFormController,
                          decoration: const InputDecoration(
                            labelText: "Google Form URL",
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  // Chapters Section
                  if (courseId != null && fetchedCourseTitle != null)
                    Expanded(
                      child: EditChapterComponent(
                        courseId: courseId!,
                        initialCourseTitle: fetchedCourseTitle!,
                        chaptersData: chaptersData,
                        onSave: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Course updated successfully!')),
                          );
                        },
                      ),
                    ),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
