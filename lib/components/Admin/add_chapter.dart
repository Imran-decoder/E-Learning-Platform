import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_quiz.dart';

class AddChapter extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController chapterNoController;
  final TextEditingController videoLinkController;
  final TextEditingController documentLinkController;
  final VoidCallback onRemove;
  final DocumentReference courseRef;

  const AddChapter({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.chapterNoController,
    required this.videoLinkController,
    required this.documentLinkController,
    required this.onRemove,
    required this.courseRef,
  });

  @override
  _AddChapterState createState() => _AddChapterState();
}

class _AddChapterState extends State<AddChapter> {
  List<Widget> quizScreens = []; // List to store dynamically added quiz screens

  void _addQuizScreen() {
    setState(() {
      quizScreens.add(AddQuizScreen(courseId: 'courseId', taskId: 'taskId')); // Add a quiz screen dynamically
    });
  }

  void _removeQuizScreen() {
    setState(() {
      if (quizScreens.isNotEmpty) {
        quizScreens.removeLast(); // Remove the last added quiz screen
      }
    });
  }

  Future<void> _addChapterToFirestore() async {
    String title = widget.titleController.text;
    String description = widget.descriptionController.text;
    String chapterNo = widget.chapterNoController.text;
    String videoLink = widget.videoLinkController.text;
    String documentLink = widget.documentLinkController.text;

    // Add chapter data to Firestore
    Map<String, dynamic> chapterData = {
      'title': title,
      'description': description,
      'chapterNo': chapterNo,
      'videoLink': videoLink,
      'documentLink': documentLink,
    };

    DocumentReference chapterRef = await widget.courseRef.collection('chapters').add(chapterData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chapter added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
            ..._buildChapterDetailsFields(),
            ElevatedButton(
              onPressed: _addQuizScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Add Quiz Screen',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: _removeQuizScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Remove Last Quiz Screen',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Display the dynamically added quiz screens
            Column(
              children: quizScreens,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: widget.onRemove,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Remove Chapter',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _addChapterToFirestore,
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
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChapterDetailsFields() {
    return [
      _buildTextField(widget.titleController, "Title"),
      _buildTextField(widget.descriptionController, "Description"),
      _buildTextField(widget.chapterNoController, "Chapter No"),
      _buildTextField(widget.videoLinkController, "Video Link"),
      _buildTextField(widget.documentLinkController, "Document Link"),
    ];
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.black54,
        ),
      ),
    );
  }
}
