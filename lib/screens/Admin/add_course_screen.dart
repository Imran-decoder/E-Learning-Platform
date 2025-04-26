import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddQuizScreen extends StatelessWidget {
  final TextEditingController questionController;
  final List<TextEditingController> options;
  final TextEditingController correctAnswerController;
  final VoidCallback onRemove;

  const AddQuizScreen({
    super.key,
    required this.questionController,
    required this.options, // List of option controllers
    required this.correctAnswerController,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter Quiz Details",
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

          // Options Fields with consistent space between each
          for (var i = 0; i < 4; i++) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0), // Space between each option
              child: TextField(
                controller: options[i],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Option ${i + 1}",
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.black54,
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),

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

class AddChapter extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController  chapterNoController;
  final TextEditingController videoLinkController;
  final TextEditingController durationController;
  final TextEditingController documentLinkController;
  final TextEditingController quizLinkController;
  final VoidCallback onRemove;

  const AddChapter({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.chapterNoController,
    required this.videoLinkController,
    required this.durationController,
    required this.documentLinkController,
    required this.quizLinkController,
    required this.onRemove,
  });

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
            "Enter Chapter Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Chapter Number Field
          TextField(
            controller: widget.chapterNoController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Chapter Number",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
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

          // Duration Field
          TextField(
            controller: widget.durationController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Duration (in minutes)",
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
  String? _logo = "https://upload.wikimedia.org/wikipedia/commons/0/0e/DefaultImage.png";
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Map<String, dynamic>> chapters = [];
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // Modify to ensure that logo isn't stored as null
  // Future<void> _setImageUrl() async {
  //   final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       // If an image is selected, store its path
  //       _logo = pickedFile.path;
  //     } else {
  //       _logo = _logo ?? "url_to_image";  // Ensuring the default URL is used if logo is null
  //     }
  //   });
  // }

  void _addChapter() {
    setState(() {
      chapters.add({
        'title': TextEditingController(),
        'description': TextEditingController(),
        'number': TextEditingController(),
        'video': TextEditingController(),
        'duration': TextEditingController(),
        'document' : TextEditingController(),
        'quizLink': TextEditingController(),//google form link
        'quizzes': [],
        'googleFormUrls': [], // Initialize the list for Google Form URLs
      });
    });
  }

  void _removeChapter(int index) {
    setState(() {
      chapters.removeAt(index);
    });
  }

  void _addQuiz(int chapterIndex) {
    setState(() {
      chapters[chapterIndex]['quizzes'].add({
        'question': TextEditingController(),
        'options': List.generate(4, (index) => TextEditingController()),  // Ensure this list is initialized
        'correctAnswer': TextEditingController(),
      });
    });
  }

  void _addGoogleFormUrl(int chapterIndex) {
    setState(() {
      chapters[chapterIndex]['googleFormUrls'].add(TextEditingController());
    });
  }

  void _removeGoogleFormUrl(int chapterIndex, int urlIndex) {
    setState(() {
      chapters[chapterIndex]['googleFormUrls'].removeAt(urlIndex);
    });
  }


  void _removeQuiz(int chapterIndex, int quizIndex) {
    setState(() {
      chapters[chapterIndex]['quizzes'].removeAt(quizIndex);
    });
  }

  void _addCourse() async {
    setState(() {
      _isLoading = true;
    });

    String courseTitle = _titleController.text;

    if (courseTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course title is required')));
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Ensure that logo is not null
    if (_logo == null || _logo!.isEmpty) {
      _logo = "url_to_image";  // Set default image URL if no logo is selected
    }

    Map<String, dynamic> courseData = {
      'title': courseTitle,
      'logo': _logo,
    };

    try {
      DocumentReference courseRef = await FirebaseFirestore.instance.collection('Courses').add(courseData);

      for (var chapter in chapters) {
        String chapterTitle = chapter['title']!.text;
        String chapterDescription = chapter['description']!.text;
        String chapterNumber = chapter['number']!.text;
        String chapterVideo = chapter['video']!.text;
        String chapterDuration = chapter['duration']!.text;
        String chapterDocument = chapter['document']!.text;
        String chapterQuizLink = chapter['quizLink']!.text;
        if (chapterTitle.isEmpty || chapterDescription.isEmpty || chapterNumber.isEmpty) {
          continue;  // Skip this chapter if any essential fields are empty
        }

        Map<String, dynamic> taskData = {
          'title': chapterTitle,
          'description': chapterDescription,
          'number': int.tryParse(chapterNumber) ?? 0,
          'video': chapterVideo.isEmpty ? "" : chapterVideo,  // Default empty string if no video link
          'duration': chapterDuration.isEmpty ? "" : chapterDuration,  // Default empty string if no duration
          'document' : chapterDocument.isEmpty ? "" : chapterDocument,
          'quizLink': chapterQuizLink.isEmpty ? "" : chapterQuizLink,  // Default empty string if no quiz link
        };

        DocumentReference chapterRef = await courseRef.collection('tasks').add(taskData);

        for (var quiz in chapter['quizzes']) {
          String question = quiz['question']!.text;
          List<String> options = [
            quiz['options'][0]!.text,
            quiz['options'][1]!.text,
            quiz['options'][2]!.text,
            quiz['options'][3]!.text,
          ];
          String correctAnswer = quiz['correctAnswer']!.text;

          if (question.isEmpty || correctAnswer.isEmpty || options.any((opt) => opt.isEmpty)) {
            continue;  // Skip quiz if any essential field is empty
          }

          Map<String, dynamic> quizData = {
            'question': question,
            'options': options,
            'correctAnswer': correctAnswer,
          };

          await chapterRef.collection('quizQuestions').add(quizData);
        }
      }
      // Send Notification (Message) after adding course
      await sendCourseAddedNotification(courseTitle);

    } catch (e) {
      print('Error adding course: $e');
    }

    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      chapters.clear();
      _logo = null;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course added successfully')));
  }

Future<void> sendCourseAddedNotification(String courseTitle) async {
    try{
      String notificationTitle = "New Course Added";
      String notificationBody = "New course $courseTitle has been added to the platform.";

      // ✅ Step 1: Store notification in Firestore (for in-app notification screen)
      await FirebaseFirestore.instance.collection('notifications').add({
        'title': notificationTitle,
        'body': notificationBody,
        'timestamp': FieldValue.serverTimestamp(),
        'expiry': DateTime.now().add(Duration(hours: 24)), // 24 hours expiry
      });

      // ✅ Step 2: Send push notification to users via FCM
      await sendPushNotification(notificationTitle, notificationBody);
    } catch (e){
     print('Error sending Notification $e');
    }
}

// Function to send FCM Push Notification
  Future<void> sendPushNotification(String title, String body) async {
    try {
      String serverKey = '7412734dc7727d8078ae52dd2d6f956e26815c14';

      // Step 1: Fetch user FCM tokens from Firestore
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();

      // Step 2: Collect FCM tokens from users
      List<String> userTokens = usersSnapshot.docs.map((doc) => doc['fcm_token'] as String).toList();

      // Step 3: Send the notification to all users (if tokens exist)
      if (userTokens.isNotEmpty) {
        for (String token in userTokens) {
          var response = await http.post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverKey', // Auth with FCM
            },
            body: jsonEncode({
              'to': token,  // Send notification to each user individually
              'notification': {
                'title': title,
                'body': body,
              },
              'data': {
                'screen': '/screen/notification_screen',  // Used for navigation when tapped
              },
            }),
          );
          print("Sending notification to user: $token");
          print("FCM Response: ${response.body}");
        }
      }
    } catch (e) {
      print("Error sending FCM push notification: $e");
    }
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
                // GestureDetector(
                //  // onTap: _setImageUrl,
                //   child: Container(
                //     width: double.infinity,
                //     height: 200,
                //     decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(12)),
                //     child: _logo == null
                //         ? const Center(
                //      // child: Icon(Icons.add_a_photo, color: Colors.white, size: 40),
                //     )
                //         : Image.network(
                //       _logo!,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 20),

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
                  children: List.generate(chapters.length, (chapterIndex) {
                    return Column(
                      children: [
                        AddChapter(
                          titleController: chapters[chapterIndex]['title']!,
                          descriptionController: chapters[chapterIndex]['description']!,
                          chapterNoController: chapters[chapterIndex]['number']!,
                          videoLinkController: chapters[chapterIndex]['video']!,
                          durationController: chapters[chapterIndex]['duration']!,
                          documentLinkController: chapters[chapterIndex]['document']!,
                          quizLinkController: chapters[chapterIndex]['quizLink'],
                          onRemove: () => _removeChapter(chapterIndex), 
                        ),
                        // Add quiz button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ElevatedButton.icon(
                            onPressed: () => _addQuiz(chapterIndex),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: Size(MediaQuery.of(context).size.width - 40, 50),
                            ),
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text(
                                'Add Quiz',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            ),
                          ),
                        ),

                        // Add Google Form URL button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ElevatedButton.icon(
                            onPressed: () => _addGoogleFormUrl(chapterIndex),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: Size(MediaQuery.of(context).size.width - 40, 50),
                            ),
                            icon: const Icon(Icons.add_link, color: Colors.white),
                            label: const Text(
                              'Add Google Form URL',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Render Google Form URLs for this chapter
                        Column(
                          children: List.generate(chapters[chapterIndex]['googleFormUrls']?.length ?? 0, (urlIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: chapters[chapterIndex]['googleFormUrls'][urlIndex],
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        labelText: "Google Form URL",
                                        labelStyle: TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                    onPressed: () => _removeGoogleFormUrl(chapterIndex, urlIndex),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),

                        // Render quizzes for this chapter
                        Column(
                          children: List.generate(chapters[chapterIndex]['quizzes']?.length ?? 0, (quizIndex) {
                            return AddQuizScreen(
                              questionController: chapters[chapterIndex]['quizzes'][quizIndex]['question']!,
                              options: chapters[chapterIndex]['quizzes'][quizIndex]['options']!,
                              correctAnswerController: chapters[chapterIndex]['quizzes'][quizIndex]['correctAnswer']!,
                              onRemove: () => _removeQuiz(chapterIndex, quizIndex),
                            );
                          }),
                        ),
                      ],
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
