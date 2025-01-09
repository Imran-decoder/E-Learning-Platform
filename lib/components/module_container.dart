import 'package:flutter/material.dart';

// Component: ModuleContainer
class ModuleContainer extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ModuleContainer({
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.deepOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepOrange),
          ],
        ),
      ),
    );
  }
}

// Screen: CourseDetailScreen
class CourseDetailScreen extends StatelessWidget {
  final String courseName;
  final List<Map<String, String>> modules;

  const CourseDetailScreen({
    required this.courseName,
    required this.modules,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return ModuleContainer(
            title: module['title']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseModuleScreen(
                    moduleTitle: module['title']!,
                    moduleContent: module['content']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Screen: CourseModuleScreen
class CourseModuleScreen extends StatelessWidget {
  final String moduleTitle;
  final String moduleContent;

  const CourseModuleScreen({
    required this.moduleTitle,
    required this.moduleContent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(moduleTitle),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          moduleContent,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}

// Example Usage
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      {'title': 'Module 1: Introduction', 'content': 'This is the introduction content.'},
      {'title': 'Module 2: Basics', 'content': 'This is the basics content.'},
      {'title': 'Module 3: Advanced Topics', 'content': 'This is the advanced content.'},
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CourseDetailScreen(
        courseName: 'Flutter Development',
        modules: modules,
      ),
    );
  }
}
