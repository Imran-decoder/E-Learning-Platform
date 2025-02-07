import 'package:flutter/material.dart';
import 'detail_info_screen.dart';
import 'package:elearning/components/header_section.dart';
import 'package:elearning/screens/task_list_screen.dart';
import 'package:elearning/db_operations/courses.dart';

class Section {
  final String title;
  final String content;
  final String duration;
  final int number;
  final String videoUrl;
  final String taskId;

  Section({
    required this.title,
    required this.content,
    required this.duration,
    required this.number,
    required this.videoUrl,
    required this.taskId,
  });

  // Helper method to convert Task to Section
  static Section fromTask(Task task) {
    return Section(
      title: task.title,
      content: task.description,
      duration: task.duration,
      number: task.number,
      videoUrl: task.video,
      taskId: task.id,
    );
  }
}

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;
  final String userId;

  const CourseDetailsScreen({
    required this.courseId,
    required this.userId,
    super.key,
  });

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

  // Convert tasks to sections and add introduction
  List<Section> _createSectionsFromCourse(Course course) {
    List<Section> sections = [];

    course.tasks.sort((a, b) => a.number.compareTo(b.number));

    for (var i = 0; i < course.tasks.length; i++) {
      sections.add(Section(
        title: 'Chapter ${i + 1}',
        content: course.tasks[i].description,
        duration: course.tasks[i].duration,
        number: course.tasks[i].number,
        videoUrl: course.tasks[i].video,
        taskId: course.tasks[i].id,
      ));
      // debugPrint('Quiz URL for Section ${i + 1}: ${sections[i].quizUrl} ${sections[i].number}');
    }

    return sections;
  }

  Future<void> _loadCourseData() async {
    try {
      setState(() => _isLoading = true);
      final courseData = await _repository.getCourseWithTasks(widget.courseId);
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
        title: Text(_course!.title),
        backgroundColor: Colors.deepOrange,
     
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Overview
              const Text(
                'Course Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),

              // Sections/Chapters
              // Removed Expanded, use shrinkWrap instead
              ListView.builder(
                shrinkWrap:
                    true, // This ensures that ListView takes only as much space as it needs
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent scrolling within ListView
                itemCount: _sections.length,
                itemBuilder: (context, index) {
                  final section = _sections[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: HeaderSection(
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
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              // Task Management Section
              const SizedBox(height: 24),
              
            ],
          ),
        ),
      ),
      
    );
  }
}
