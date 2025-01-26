import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<Map<String, TextEditingController>> quizzes = [];

  void _addQuiz() {
    setState(() {
      quizzes.add({
        'question': TextEditingController(),
        'option1': TextEditingController(),
        'option2': TextEditingController(),
        'option3': TextEditingController(),
        'option4': TextEditingController(),
        'correctAnswer': TextEditingController(),
      });
    });
  }

  void _removeQuiz(int index) {
    setState(() {
      quizzes.removeAt(index);
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

    // Add quiz data to the chapter
    for (var quiz in quizzes) {
      Map<String, dynamic> quizData = {
        'question': quiz['question']!.text,
        'option1': quiz['option1']!.text,
        'option2': quiz['option2']!.text,
        'option3': quiz['option3']!.text,
        'option4': quiz['option4']!.text,
        'correctAnswer': quiz['correctAnswer']!.text,
      };
      await chapterRef.collection('quizzes').add(quizData);
    }

    // Clear inputs and quizzes list after adding
    setState(() {
      quizzes.clear();
      widget.titleController.clear();
      widget.descriptionController.clear();
      widget.chapterNoController.clear();
      widget.videoLinkController.clear();
      widget.documentLinkController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chapter and quizzes added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Make the whole screen scrollable
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

            // Chapter Details Fields
            ..._buildChapterDetailsFields(),

            // Add Quiz Button
            ElevatedButton(
              onPressed: _addQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Add Quiz',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),

            // List of Quiz Questions
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                return _buildQuizForm(index);
              },
            ),
            const SizedBox(height: 10),

            // Remove Last Quiz Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (quizzes.isNotEmpty) {
                    _removeQuiz(quizzes.length - 1);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Remove Last Quiz',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            // Remove Chapter Button
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

            // Add Chapter Button
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

  Widget _buildQuizForm(int index) {
    return Column(
      children: [
        const Text(
          "Enter Quiz Question",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        _buildQuizTextField(index, 'Question', 'question'),
        _buildQuizTextField(index, 'Option 1', 'option1'),
        _buildQuizTextField(index, 'Option 2', 'option2'),
        _buildQuizTextField(index, 'Option 3', 'option3'),
        _buildQuizTextField(index, 'Option 4', 'option4'),
        _buildQuizTextField(index, 'Correct Answer', 'correctAnswer'),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () => _removeQuiz(index),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizTextField(int index, String label, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: quizzes[index][key]!,
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
