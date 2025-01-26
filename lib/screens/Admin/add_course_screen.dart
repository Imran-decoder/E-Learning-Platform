import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddChapter extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController chapterNoController;
  final TextEditingController videoLinkController;
  final TextEditingController documentLinkController;
  final VoidCallback onRemove;

  const AddChapter({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.chapterNoController,
    required this.videoLinkController,
    required this.documentLinkController,
    required this.onRemove,
  }) : super(key: key);

  @override
  _AddChapterState createState() => _AddChapterState();
}

class _AddChapterState extends State<AddChapter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter Task Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Title Field
          TextField(
            controller: widget.titleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Title",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // Description Field
          TextField(
            controller: widget.descriptionController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Description",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // Chapter Number Field
          TextField(
            controller: widget.chapterNoController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Chapter No",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // Video Link Field
          TextField(
            controller: widget.videoLinkController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Video Link",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // Document Link Field
          TextField(
            controller: widget.documentLinkController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Document Link",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),

          // Remove Button
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: widget.onRemove,
            ),
          ),
        ],
      ),
    );
  }
}

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  String? _logo;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Map<String, TextEditingController>> chapters = [];
  bool _isLoading = false;

  void _setImageUrl() {
    setState(() {
      _logo = "https://example.com/your-image-url.jpg"; // Example URL
    });
  }

  void _addChapter() {
    setState(() {
      chapters.add({
        'title': TextEditingController(),
        'description': TextEditingController(),
        'number': TextEditingController(),
        'video': TextEditingController(),
        'document': TextEditingController(),
      });
    });
  }

  void _removeChapter(int index) {
    setState(() {
      chapters.removeAt(index);
    });
  }

  void _addCourse() async {
    setState(() {
      _isLoading = true;
    });

    String courseTitle = _titleController.text;

    // Create the course data to save in Firebase
    Map<String, dynamic> courseData = {
      'title': courseTitle,
      'logo': _logo,
    };

    // Save the course to Firestore
    DocumentReference courseRef = await FirebaseFirestore.instance.collection('Courses').add(courseData);

    // Save each chapter under the 'tasks' sub-collection
    for (var chapter in chapters) {
      Map<String, dynamic> taskData = {
        'title': chapter['title']!.text,
        'description': chapter['description']!.text,
        'number': chapter['number']!.text,
        'video': chapter['video']!.text,
        'document': chapter['document']!.text,
      };

      // Add task (chapter) to the specific course document in Firestore
      await courseRef.collection('tasks').add(taskData);
    }

    // Reset the form after adding the course
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      chapters.clear();
      _logo = null;
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course added successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter Course Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Course Image Selection
                GestureDetector(
                  onTap: _setImageUrl,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(12)),
                    child: _logo == null
                        ? const Center(
                      child: Icon(Icons.add_a_photo, color: Colors.white, size: 40),
                    )
                        : Image.network(
                      _logo!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Course Title Field
                TextField(
                  controller: _titleController,
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

                // Chapters List
                Column(
                  children: List.generate(chapters.length, (index) {
                    return AddChapter(
                      titleController: chapters[index]['title']!,
                      descriptionController: chapters[index]['description']!,
                      chapterNoController: chapters[index]['number']!,
                      videoLinkController: chapters[index]['video']!,
                      documentLinkController: chapters[index]['document']!,
                      onRemove: () => _removeChapter(index),
                    );
                  }),
                ),

                // Buttons for Adding Chapter and Adding Course
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _addChapter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(MediaQuery.of(context).size.width / 2 - 24, 60),
                      ),
                      child: const Text(
                        'Add Chapter',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _addCourse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(MediaQuery.of(context).size.width / 2 - 24, 60),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Add Course',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
