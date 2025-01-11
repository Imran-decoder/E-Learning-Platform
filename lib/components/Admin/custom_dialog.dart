import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.grey[850],
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              content,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Divider(
              color: Colors.grey[700],
              thickness: 1,
            ),
          ],
        ),
        actions: actions,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            ),
        );
    }
}