import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuizScreen extends StatefulWidget {
  final String courseId;
  final String taskId;

  const AddQuizScreen({
    super.key,
    required this.courseId,
    required this.taskId,
  });

  @override
  _AddQuizScreenState createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  List<Map<String, TextEditingController>> quizQuestions = [];

  void _addQuestion() {
    setState(() {
      quizQuestions.add({
        'question': TextEditingController(),
        'option1': TextEditingController(),
        'option2': TextEditingController(),
        'option3': TextEditingController(),
        'option4': TextEditingController(),
        'correctAnswer': TextEditingController(),
      });
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      quizQuestions.removeAt(index);
    });
  }

  void _addQuiz() async {
    // Save each question to Firestore
    for (var question in quizQuestions) {
      Map<String, dynamic> quizData = {
        'question': question['question']!.text,
        'option1': question['option1']!.text,
        'option2': question['option2']!.text,
        'option3': question['option3']!.text,
        'option4': question['option4']!.text,
        'correctAnswer': question['correctAnswer']!.text,
      };

      // Save each question to Firestore under the correct course and task
      await FirebaseFirestore.instance
          .collection('Courses')
          .doc(widget.courseId)
          .collection('tasks')
          .doc(widget.taskId)
          .collection('quizQuestions')
          .add(quizData);
    }

    // Reset the form after adding the quiz
    setState(() {
      quizQuestions.clear();
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz added successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quiz'),
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
                  "Enter Quiz Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: quizQuestions.length,
                  itemBuilder: (context, index) {
                    return AddQuiz(
                      questionController: quizQuestions[index]['question']!,
                      option1Controller: quizQuestions[index]['option1']!,
                      option2Controller: quizQuestions[index]['option2']!,
                      option3Controller: quizQuestions[index]['option3']!,
                      option4Controller: quizQuestions[index]['option4']!,
                      correctAnswerController: quizQuestions[index]['correctAnswer']!,
                      onRemove: () => _removeQuestion(index),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _addQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(MediaQuery.of(context).size.width / 2 - 24, 60),
                      ),
                      child: const Text(
                        'Add Question',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _addQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(MediaQuery.of(context).size.width / 2 - 24, 60),
                      ),
                      child: const Text(
                        'Add Quiz',
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

class AddQuiz extends StatelessWidget {
  final TextEditingController questionController;
  final TextEditingController option1Controller;
  final TextEditingController option2Controller;
  final TextEditingController option3Controller;
  final TextEditingController option4Controller;
  final TextEditingController correctAnswerController;
  final VoidCallback onRemove;

  const AddQuiz({
    Key? key,
    required this.questionController,
    required this.option1Controller,
    required this.option2Controller,
    required this.option3Controller,
    required this.option4Controller,
    required this.correctAnswerController,
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
            "Enter Quiz Question",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Question Field
          TextField(
            controller: questionController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Question",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // Option 1 Field
          TextField(
            controller: option1Controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Option 1",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),

          // Option 2 Field
          TextField(
            controller: option2Controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Option 2",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),

          // Option 3 Field
          TextField(
            controller: option3Controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Option 3",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),

          // Option 4 Field
          TextField(
            controller: option4Controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Option 4",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),

          // Correct Answer Field
          TextField(
            controller: correctAnswerController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Correct Answer",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // Remove Question Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onRemove,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Remove Question',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
