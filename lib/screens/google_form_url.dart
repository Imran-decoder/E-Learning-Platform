import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleFormUrl extends StatefulWidget {
  final String courseId;
  final String userId;

  const GoogleFormUrl({
    super.key,
    required this.courseId,
    required this.userId,
  });

  @override
  State<GoogleFormUrl> createState() => _GoogleFormUrlState();
}

class _GoogleFormUrlState extends State<GoogleFormUrl> {
  String? googleFormUrl;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _checkProgressAndFetchFormUrl();
  }

  Future<void> _checkProgressAndFetchFormUrl() async {
    try {
      // Step 1: Fetch enrolled course document
      final enrolledCourseDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('enrolledCourses')
          .doc(widget.courseId)
          .get();

      if (!enrolledCourseDoc.exists) {
        setState(() {
          errorMessage = 'Enrolled course not found.';
          isLoading = false;
        });
        return;
      }

      final enrolledData = enrolledCourseDoc.data()!;
      final tasks = enrolledData['tasks'] ?? {};
      final totalTasks = tasks.length;
      final completedTasks = tasks.values.where((v) => v == true).length;
      final progress = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0;

      if (progress < 80) {
        setState(() {
          errorMessage = 'Progress is below 80%. Minimum 80% required to access the form.';
          isLoading = false;
        });
        return;
      }

      // Step 2: Fetch Google Form URL
      final formSnapshot = await FirebaseFirestore.instance
          .collection('Courses')
          .doc(widget.courseId)
          .collection('googleForm')
          .limit(1)
          .get();

      if (formSnapshot.docs.isNotEmpty) {
        final url = formSnapshot.docs.first.data()['url'];
        if (url != null && url.toString().startsWith('http')) {
          setState(() {
            googleFormUrl = url;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Form URL is invalid or missing.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Google Form not found for this course.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Google Form')),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Form',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        // backgroundColor: const Color.fromRGBO(255, 110, 65, 1.0),
      ),
        
      body:WebViewWidget(
      controller: WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(googleFormUrl!)),
    ),
    );
  }
}
