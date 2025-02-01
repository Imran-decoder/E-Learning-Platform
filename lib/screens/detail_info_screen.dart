import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'quiz_screen.dart';

class DetailedInfoScreen extends StatefulWidget {
  final String courseId;
  final String taskId;
  final String title;
  final String content;
  final String duration;
  final int number;
  final String videoUrl;

  const DetailedInfoScreen({
    required this.courseId,
    required this.taskId,
    required this.title,
    required this.content,
    required this.duration,
    required this.number,
    required this.videoUrl,
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

          if (taskScores != null) {
            if (taskScores.containsKey(widget.taskId)) {
              final score = taskScores[widget.taskId];
              if (score != null && score >= 70.0) {
                setState(() {
                  isCourseCompleted = true;
                });
              }
            }
          }
        }
      }
    } catch (e) {
      //print("Error checking task completion: $e");
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
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
        const SnackBar(
          content: Text('No quiz available for this chapter.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepOrangeAccent, // Use green for a fresh look
        elevation: 0, // Remove shadow for a flat design
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // Rounded corners for the video player
              child: YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(
                  Icons.timer, // Icon for duration
                  color: Colors.deepOrangeAccent,
                  size: 20,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Duration: ${widget.duration} seconds',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Description: ',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24.0),

            // "Course Completed" Button
            Center(
              child: ElevatedButton(
                onPressed: isCourseCompleted ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCourseCompleted ? Colors.deepOrangeAccent : Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded button
                  ),
                  shadowColor: Colors.green.withOpacity(0.4), // Button shadow
                  elevation: 8, // Elevated button for a modern look
                ),
                child: const Text(
                  'Course Completed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Take Quiz Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _navigateToQuizScreen,
                icon: const Icon(Icons.quiz, size: 24),
                label: const Text(
                  'Take Quiz',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
