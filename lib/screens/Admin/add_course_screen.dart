import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'dart:io'; // Import dart:io for File class

class AddChapter extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController chapterNoController;
  final TextEditingController videoLinkController;
  final TextEditingController quizLinkController;
  final TextEditingController documentLinkController;
  final VoidCallback onRemove;

  const AddChapter({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.chapterNoController,
    required this.videoLinkController,
    required this.quizLinkController,
    required this.documentLinkController,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter Chapter Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Title Field
          TextField(
            controller: titleController,
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
            controller: descriptionController,
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
            controller: chapterNoController,
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
            controller: videoLinkController,
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

          // Quiz Link Field
          TextField(
            controller: quizLinkController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Quiz Link",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // Document Link Field
          TextField(
            controller: documentLinkController,
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
              onPressed: onRemove,
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
  XFile? _image; // Store selected image

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // List to store each chapter's controllers
  List<Map<String, TextEditingController>> chapters = [];

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedImage;
    });
  }

  // Function to add a new chapter
  void _addChapter() {
    setState(() {
      chapters.add({
        'title': TextEditingController(),
        'description': TextEditingController(),
        'chapterNo': TextEditingController(),
        'videoLink': TextEditingController(),
        'quizLink': TextEditingController(),
        'documentLink': TextEditingController(),
      });
    });
  }

  // Function to remove a chapter
  void _removeChapter(int index) {
    setState(() {
      chapters.removeAt(index);
    });
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
        child: SingleChildScrollView( // Make the entire content scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter Course Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Image Selection Button
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _image == null
                        ? const Center(
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 40,
                      ),
                    )
                        : Image.file(
                      File(_image!.path),
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

                // Course Description Field
                TextField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Course Description",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),

                // Dynamic Chapter List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    return AddChapter(
                      titleController: chapters[index]['title']!,
                      descriptionController: chapters[index]['description']!,
                      chapterNoController: chapters[index]['chapterNo']!,
                      videoLinkController: chapters[index]['videoLink']!,
                      quizLinkController: chapters[index]['quizLink']!,
                      documentLinkController: chapters[index]['documentLink']!,
                      onRemove: () => _removeChapter(index),
                    );
                  },
                ),

                // Add Chapter and Add Course Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Add Chapter Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(MediaQuery.of(context).size.width / 2 - 24, 60),
                      ),
                      onPressed: _addChapter,
                      child: const Text(
                        '+ Add Chapter',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    // Add Course Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(MediaQuery.of(context).size.width / 2 - 24, 60),
                      ),
                      onPressed: () {
                        // Add functionality to submit the form (e.g., save course details)
                      },
                      child: const Text(
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
