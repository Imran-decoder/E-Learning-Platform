import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditChapterComponent extends StatefulWidget {
  final String courseId;
  final String initialCourseTitle;
  final Map<String, Map<String, dynamic>> chaptersData;
  final VoidCallback onSave;

  const EditChapterComponent({
    required this.courseId,
    required this.initialCourseTitle,
    required this.chaptersData,
    required this.onSave,
    super.key,
  });

  @override
  _EditChapterComponentState createState() => _EditChapterComponentState();
}

class _EditChapterComponentState extends State<EditChapterComponent> {
  final TextEditingController _courseTitleController = TextEditingController();
  late Map<String, Map<String, dynamic>> chaptersData;

  @override
  void initState() {
    super.initState();
    _courseTitleController.text = widget.initialCourseTitle; // Set initial title
    chaptersData = Map.from(widget.chaptersData); // Make a local copy
  }

  // Save updated course title and chapters data to Firestore
  void _saveChanges() async {
    try {
      // Update course title
      await FirebaseFirestore.instance
          .collection('Courses')
          .doc(widget.courseId)
          .update({'title': _courseTitleController.text});

      // Update chapters
      for (var chapterId in chaptersData.keys) {
        await FirebaseFirestore.instance
            .collection('Courses')
            .doc(widget.courseId)
            .collection('tasks')
            .doc(chapterId)
            .update({
          'title': chaptersData[chapterId]?['title'],
          'description': chaptersData[chapterId]?['description'],
          'number': chaptersData[chapterId]?['number'],
          'video': chaptersData[chapterId]?['video'],
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course updated successfully!')),
      );
      widget.onSave();
    } catch (e) {
      print("Error saving changes: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save changes.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Set background color to black
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit Course Title
          TextField(
            controller: _courseTitleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Course Title",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black45,
            ),
          ),
          const SizedBox(height: 20),

          // List of Chapters
          Expanded(
            child: ListView.builder(
              itemCount: chaptersData.length,
              itemBuilder: (context, index) {
                var chapterId = chaptersData.keys.elementAt(index);
                var chapter = chaptersData[chapterId]!;

                return Card(
                  color: Colors.black54,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chapter Title
                        TextField(
                          controller: TextEditingController(text: chapter['title']),
                          onChanged: (value) {
                            setState(() {
                              chaptersData[chapterId]!['title'] = value;
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Chapter Title",
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black45,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Chapter Number
                        TextField(
                          controller: TextEditingController(text: chapter['number'].toString()),
                          onChanged: (value) {
                            setState(() {
                              chaptersData[chapterId]!['number'] = int.tryParse(value) ?? 0;
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Chapter Number",
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black45,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Chapter Description
                        TextField(
                          controller: TextEditingController(text: chapter['description']),
                          onChanged: (value) {
                            setState(() {
                              chaptersData[chapterId]!['description'] = value;
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Description",
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black45,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Chapter Video URL
                        TextField(
                          controller: TextEditingController(text: chapter['video']),
                          onChanged: (value) {
                            setState(() {
                              chaptersData[chapterId]!['video'] = value;
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Video URL",
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black45,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _saveChanges,
              child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
