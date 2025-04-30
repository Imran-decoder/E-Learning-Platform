import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'detail_info_screen.dart';
import 'feedback_form_screen.dart';
import 'package:elearning/components/header_section.dart';
import 'package:elearning/db_operations/courses.dart';
import 'package:elearning/screens/google_form_url.dart';

class Section {
  final String title;
  final String content;
  final String duration;
  final int number;
  final String videoUrl;
  final String taskId;
  final String document;

  Section({
    required this.title,
    required this.content,
    required this.duration,
    required this.number,
    required this.videoUrl,
    required this.taskId,
    required this.document,
  });

  static Section fromTask(Task task) {
    return Section(
      title: task.title,
      content: task.description,
      duration: task.duration,
      number: task.number,
      videoUrl: task.video,
      taskId: task.id,
      document: task.document ?? '',
    );
  }
}

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;
  final String userId;

  const CourseDetailsScreen(
      {required this.courseId, required this.userId, super.key});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final CourseRepository _repository = CourseRepository();
  bool _isLoading = true;
  String? _error;
  Course? _course;
  late List<Section> _sections;

  @override
  void initState() {
    super.initState();
    _loadCourseData();
  }

  List<Section> _createSectionsFromCourse(Course course) {
    List<Section> sections = [];
    course.tasks.sort((a, b) => a.number.compareTo(b.number));

    for (var i = 0; i < course.tasks.length; i++) {
      var task = course.tasks[i];

      sections.add(Section(
        title: 'Chapter ${i + 1}',
        content: task.description,
        duration: task.duration,
        number: task.number,
        videoUrl: task.video,
        taskId: task.id,
        document: task.document ?? '',
      ));
    }

    return sections;
  }

  Future<void> _loadCourseData() async {
    try {
      if (!mounted) return;
      setState(() => _isLoading = true);
      final courseData = await _repository.getCourseWithTasks(widget.courseId);
      if (!mounted) return;
      if (courseData == null) {
        setState(() {
          _error = 'Course not found';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _course = courseData;
        _sections = _createSectionsFromCourse(courseData);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading course: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _loadCourseData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _course!.title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(255, 110, 65, 1.0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Course Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _sections.length,
                itemBuilder: (context, index) {
                  final section = _sections[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderSection(
                          title: section.title,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedInfoScreen(
                                  title: section.title,
                                  content: section.content,
                                  duration: section.duration,
                                  number: section.number,
                                  videoUrl: section.videoUrl,
                                  taskId: section.taskId,
                                  courseId: widget.courseId,
                                  document: section.document,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoogleFormUrl(
                          courseId: widget.courseId,
                          userId: widget.userId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    ' Google Form Final Exam ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedbackFormScreen(
                courseId: widget.courseId,
                userId: widget.userId,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: const Icon(
            Icons.feedback,
            color: Colors.white54,
            size: 30,
          ),
        ),
      ),
    );
  }
}
