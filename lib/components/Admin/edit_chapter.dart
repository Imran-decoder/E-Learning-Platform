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
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, List<Map<String, dynamic>>> _quizQuestions = {}; // To hold quiz data for each chapter
  final Map<String, List<TextEditingController>> _quizControllers = {}; // For editing quiz questions
  final Map<String, List<String>> _correctAnswers = {}; // To store correct answers for each quiz

  @override
  void initState() {
    super.initState();
    _courseTitleController.text = widget.initialCourseTitle;
    chaptersData = Map.from(widget.chaptersData);

    // Initialize controllers for chapters
    for (var chapterId in chaptersData.keys) {
      _controllers[chapterId] = TextEditingController(
        text: chaptersData[chapterId]!['title'] ?? '',
      );
    }

    // Fetch quiz questions for each chapter
    _fetchQuizQuestions();
  }

  Future<void> _fetchQuizQuestions() async {
    for (var chapterId in chaptersData.keys) {
      // Fetch quiz questions from the 'quizQuestion' sub-collection
      QuerySnapshot quizSnapshot = await FirebaseFirestore.instance
          .collection('Courses')
          .doc(widget.courseId)
          .collection('tasks')
          .doc(chapterId)
          .collection('quizQuestions')
          .get();

      List<Map<String, dynamic>> quizData = quizSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        _quizQuestions[chapterId] = quizData;
        _quizControllers[chapterId] = List.generate(quizData.length,
                (index) => TextEditingController(text: quizData[index]['question']));

        // Initialize the correct answers for the chapter
        _correctAnswers[chapterId] = List.generate(
            quizData.length, (index) => quizData[index]['correctAnswer'] ?? '');
      });
    }
  }

  @override
  void dispose() {
    _courseTitleController.dispose();
    // Dispose controllers for chapters
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    // Dispose quiz controllers
    for (var controllers in _quizControllers.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      // Update course title
      await FirebaseFirestore.instance
          .collection('Courses')
          .doc(widget.courseId)
          .update({'title': _courseTitleController.text});

      // Update chapters
      for (var chapterId in chaptersData.keys) {

        // Check if the chapter exists first
        DocumentSnapshot chapterSnapshot = await FirebaseFirestore.instance
            .collection('Courses')
            .doc(widget.courseId)
            .collection('tasks')
            .doc(chapterId)
            .get();

        if (chapterSnapshot.exists) {
          // If it exists, update it
          await FirebaseFirestore.instance
              .collection('Courses')
              .doc(widget.courseId)
              .collection('tasks')
              .doc(chapterId)
              .update({
            'title': _controllers[chapterId]?.text,
            'description': chaptersData[chapterId]!['description'],
            'number': chaptersData[chapterId]!['number'],
            'video': chaptersData[chapterId]!['video'] ?? '',
            'document': chaptersData[chapterId]?.containsKey('document') == true
                ? chaptersData[chapterId]!['document'] ?? ''
                : '',
            'duration' : chaptersData[chapterId]!['duration'] ?? '',
          });

          // Update quiz questions
          for (int i = 0; i < _quizQuestions[chapterId]!.length; i++) {

            DocumentSnapshot quizSnapshot = await FirebaseFirestore.instance
                .collection('Courses')
                .doc(widget.courseId)
                .collection('tasks')
                .doc(chapterId)
                .collection('quizQuestions')
                .doc(_quizQuestions[chapterId]![i]['id'])
                .get();

            if (quizSnapshot.exists) {
              await FirebaseFirestore.instance
                  .collection('Courses')
                  .doc(widget.courseId)
                  .collection('tasks')
                  .doc(chapterId)
                  .collection('quizQuestions')
                  .doc(_quizQuestions[chapterId]![i]['id'])
                  .update({
                'question': _quizControllers[chapterId]![i].text,
                'correctAnswer': _correctAnswers[chapterId]![i],
                'options': _quizQuestions[chapterId]![i]['options'],
              });
            } else {
              // Handle case where quiz question doesn't exist
            }
          }
        } else {
          // Handle case where the chapter doesn't exist
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course updated successfully!')),
      );
      widget.onSave();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
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

                return Card(
                  color: Colors.black54,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Chapter Number
                        TextField(
                          controller: TextEditingController(
                              text: chaptersData[chapterId]!['number']
                                  ?.toString() ?? ''),
                          onChanged: (value) {
                            setState(() {
                              chaptersData[chapterId]!['number'] =
                                  int.tryParse(value) ?? 0;
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

                        // Chapter Title
                        TextField(
                          controller: _controllers[chapterId],
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


                        // Chapter Description
                        TextField(
                          controller: TextEditingController(
                              text: chaptersData[chapterId]!['description'] ?? ''),
                          onChanged: (value) {
                            setState(() {
                              chaptersData[chapterId]!['description'] = value;
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          maxLines: 5,
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
                          controller: TextEditingController(
                              text: chaptersData[chapterId]!['video'] ?? ''),
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

                        // Chapter Duration
                        TextField(
                          controller: TextEditingController(
                              text: chaptersData[chapterId]!['duration'] ?? ''),
                          onChanged: (value) {
                            setState(() {
                              chaptersData[chapterId]!['duration'] = value;
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Duration",
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black45,
                            border: OutlineInputBorder(),
                          ),
                        ),


                        // Chapter Document URL
                        TextField(
                          controller: TextEditingController(
                              text: chaptersData[chapterId]!['document'] ?? ''),
                          onChanged: (value) {
                            setState(() {
                              chaptersData[chapterId]!['document'] = value;
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Document URL",
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black45,
                            border: OutlineInputBorder(),
                          ),
                        ),

                        // Quiz Questions (Editable)
                        const SizedBox(height: 20),
                        Text(
                          'Quiz Questions',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        _quizQuestions[chapterId] == null
                            ? const Text(
                          'No quiz questions available',
                          style: TextStyle(color: Colors.white),
                        )
                            : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _quizQuestions[chapterId]!.length,
                          itemBuilder: (context, quizIndex) {
                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _quizControllers[chapterId]![quizIndex],
                                  onChanged: (value) {
                                    setState(() {
                                      _quizQuestions[chapterId]![quizIndex]['question'] = value;
                                    });
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    labelText: "Quiz Question",
                                    labelStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    fillColor: Colors.black45,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Editable options for each quiz
                                for (int optionIndex = 0;
                                optionIndex <
                                    _quizQuestions[chapterId]![quizIndex]['options'].length;
                                optionIndex++)
                                  TextField(
                                    controller: TextEditingController(
                                      text: _quizQuestions[chapterId]![quizIndex]['options'][optionIndex],
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _quizQuestions[chapterId]![quizIndex]['options'][optionIndex] = newValue;
                                      });
                                    },
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Option ${optionIndex + 1}',
                                      labelStyle: const TextStyle(color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.black45,
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                // Correct Answer Field (Editable)
                                TextField(
                                  controller: TextEditingController(
                                    text: _correctAnswers[chapterId]?[quizIndex] ?? '',
                                  ),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _correctAnswers[chapterId]![quizIndex] = newValue;
                                    });
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    labelText: "Correct Answer",
                                    labelStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    fillColor: Colors.black45,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,  // This is a fallback color for compatibility
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ).copyWith(
              // Gradient background applied through the decoration
              side: WidgetStateProperty.all(BorderSide(color: Colors.blue, width: 2)),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),


        ],
      ),
    );
  }
}
