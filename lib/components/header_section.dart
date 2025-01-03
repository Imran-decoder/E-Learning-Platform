import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const HeaderSection({
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.black26), // Black border for the container
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Section with Document Icon and Title
            Row(
              children: [
                // Document Icon on the Left
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2), // Black border
                  ),
                  child: const Icon(
                    Icons.description, // Document icon
                    color: Colors.black, // Black icon color
                  ),
                ),
                const SizedBox(width: 16), // Spacing between icon and title
                // Title Text
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // Right Section with More Icon
            IconButton(
              icon: const Icon(
                Icons.more_vert_sharp,
                color: Colors.black, // Black color for the icon
              ),
              onPressed: () {
                // Optional: Add functionality for the 'more' button
                debugPrint('More options tapped for $title');
              },
            ),
          ],
        ),
      ),
    );
  }
}
