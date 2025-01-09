import 'package:flutter/material.dart';
import 'detail_info_screen.dart';
import 'package:elearning/components/header_section.dart';
import 'package:elearning/screens/task_list_screen.dart';
import 'package:elearning/db_operations/courses.dart';

class Section {
  final String title;
  final String content;

  Section({required this.title, required this.content});

  // Helper method to convert Task to Section
  static Section fromTask(Task task) {
    return Section(
      title: task.title,
      content: task.description,
    );
  }
}

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailsScreen({
    required this.courseId,
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
    
    // Add introduction section
    sections.add(Section(
      title: 'Introduction',
      content: 'This is an introduction to ${course.title} course.',
    ));
    
    // Convert tasks to sections (chapters)
    for (var i = 0; i < course.tasks.length; i++) {
      sections.add(Section(
        title: 'Chapter ${i + 1}', // title: corurse.tasks[i].title,
        content: course.tasks[i].description,
      ));
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final wasUpdated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseEditScreen(course: _course!),
                ),
              );
              
              if (wasUpdated == true) {
                await _loadCourseData();
              }
            },
          ),
        ],
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
              Text("This is an introductory course for Project management. It covers the basics of project management and is suitable for beginners."),
              const SizedBox(height: 24),

              // Sections/Chapters
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _sections.length,
                itemBuilder: (context, index) {
                  final section = _sections[index];
                  return Padding (padding: const EdgeInsets.only(bottom:20.0),
                    child: HeaderSection(
                      title: section.title,
                       onTap: (){
                        Navigator.push(context,
                        MaterialPageRoute(builder:(context) => DetailedInfoScreen(title: section.title, content: section.content)));
                       })
                  );
                },
              ),

              // Task Management Section (preserved from original implementation)
              const SizedBox(height: 24),
              Card(
                child: ListTile(
                  title: const Text('Manage Tasks'),
                  subtitle: const Text('Add, edit, or remove course tasks'),
                  leading: const Icon(Icons.task),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    final wasModified = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskListScreen(
                          courseId: widget.courseId,
                          tasks: _course!.tasks,
                        ),
                      ),
                    );
                    
                    if (wasModified == true) {
                      await _loadCourseData();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final wasAdded = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(courseId: widget.courseId),
            ),
          );
          
          if (wasAdded == true) {
            await _loadCourseData();
          }
        },
        tooltip: 'Add New Chapter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
// Simple edit screen for the course
class CourseEditScreen extends StatefulWidget {
  final Course course;

  const CourseEditScreen({required this.course, super.key});

  @override
  State<CourseEditScreen> createState() => _CourseEditScreenState();
}

class _CourseEditScreenState extends State<CourseEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Course Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Course Description'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final repository = CourseRepository();
                  try {
                    final updatedCourse = Course(
                      id: widget.course.id,
                      title: _titleController.text,
                      logo: widget.course.logo,
                      tasks: widget.course.tasks,
                    );
                    
                    await repository.updateCourse(updatedCourse);
                    
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update course: $e')),
                    );
                  }
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}