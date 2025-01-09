import 'package:flutter/material.dart';

class CourseModulesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> modules;

  const CourseModulesScreen({required this.modules, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Modules"),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.separated(
        itemCount: modules.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          final module = modules[index];
          return ModuleCard(
            moduleName: module['moduleName'],
            description: module['description'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModuleDetailScreen(module: module),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Reusable Module Card Component
class ModuleCard extends StatelessWidget {
  final String moduleName;
  final String description;
  final VoidCallback onTap;

  const ModuleCard({
    required this.moduleName,
    required this.description,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                moduleName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Detailed Module Information Screen
class ModuleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> module;

  const ModuleDetailScreen({required this.module, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(module['moduleName']),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module['moduleName'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              module['description'],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            if (module.containsKey('details')) ...[
              const SizedBox(height: 24),
              const Text(
                "Details:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                module['details'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
