import 'package:flutter/material.dart';

class AddChapter extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController chapterNoController;
  final TextEditingController videoLinkController;
  final TextEditingController quizLinkController;
  final TextEditingController documentLinkController;

  const AddChapter({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.chapterNoController,
    required this.videoLinkController,
    required this.quizLinkController,
    required this.documentLinkController,
  }) : super(key: key);

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

          // Title Field
          TextField(
            controller: titleController,
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
            controller: descriptionController,
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

          // Chapter Number Field
          TextField(
            controller: chapterNoController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Chapter No",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),

          const SizedBox(height: 20),

          // Video Link Field
          TextField(
            controller: videoLinkController,
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

          // Quiz Link Field
          TextField(
            controller: quizLinkController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Quiz Link",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),

          const SizedBox(height: 20),

          // Document Link Field
          TextField(
            controller: documentLinkController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Document Link",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
