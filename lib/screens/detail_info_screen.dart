import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'quiz_screen.dart';

class DetailedInfoScreen extends StatefulWidget {
  final String courseId;
  final String taskId;
  final String title;
  final String content;
  final String duration;
  final int number;
  final String videoUrl;
  final String document;

  const DetailedInfoScreen({
    required this.courseId,
    required this.taskId,
    required this.title,
    required this.content,
    required this.duration,
    required this.number,
    required this.videoUrl,
    required this.document,
    super.key,
  });

  @override
  _DetailedInfoScreenState createState() => _DetailedInfoScreenState();
}

class _DetailedInfoScreenState extends State<DetailedInfoScreen> {
  late YoutubePlayerController _controller;
  bool isCourseCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(widget.videoUrl)!,
      params: const YoutubePlayerParams(
        mute: false,
        showFullscreenButton: true,
        showVideoAnnotations: false,
        enableCaption: false,
        enableJavaScript: true,
        playsInline: true,
        enableKeyboard: false,
        loop: true,
      ),
    );
    _checkTaskCompletion();
  }

  Future<void> _checkTaskCompletion() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final taskScoresDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('scores')
            .doc('taskScores')
            .get();

        if (taskScoresDoc.exists) {
          final taskScores = taskScoresDoc.data();
          if (taskScores != null && taskScores.containsKey(widget.taskId)) {
            final score = taskScores[widget.taskId];
            if (score != null && score >= 70.0) {
              setState(() {
                isCourseCompleted = true;
              });
            }
          }
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _markTaskAsCompleted() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final taskId = widget.taskId;
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('enrolledCourses')
            .doc(widget.courseId)
            .update({
          'tasks.$taskId': true,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task marked as completed.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error marking task as completed: $e')),
      );
    }
  }

  void _viewDocument() {
    if (widget.document.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentViewerScreen(docUrl: widget.document),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No document available for this course.')),
      );
    }
  }

  Future<void> _navigateToQuizScreen() async {
    final quizSnapshot = await FirebaseFirestore.instance
        .collection('Courses')
        .doc(widget.courseId)
        .collection('tasks')
        .doc(widget.taskId)
        .collection('quizQuestions')
        .get();

    final quizQuestions = quizSnapshot.docs.map((doc) => doc.data()).toList();

    if (quizQuestions.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            title: widget.title,
            quizQuestions: quizQuestions,
            courseId: widget.courseId,
            taskId: widget.taskId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No quiz available for this chapter.')),
      );
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.deepOrangeAccent, size: 20),
                const SizedBox(width: 8.0),
                Text(
                  'Duration: ${widget.duration} seconds',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24.0),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isCourseCompleted ? _markTaskAsCompleted : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCourseCompleted ? Colors.deepOrangeAccent : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 8,
                    ),
                    child: const Text('Course Completed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _viewDocument,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centers the text and icon
                      children: const [
                        Text(
                          'View Document',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8), // Adds spacing between text and icon
                        Icon(Icons.arrow_forward, color: Colors.white, size: 28),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _navigateToQuizScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centers the content
                      children: const [
                        Text(
                          'Take Quiz',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8), // Adds spacing between text and icon
                        Icon(Icons.arrow_forward, color: Colors.white, size: 28),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentViewerScreen extends StatelessWidget {
  final String docUrl;

  const DocumentViewerScreen({super.key, required this.docUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Viewer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: WebViewWidget(controller: WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(Uri.parse(docUrl))),
    );
  }
}
