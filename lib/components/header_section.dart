import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const HeaderSection({
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ], // Subtle shadow to elevate the header
          border: Border.all(color: Colors.black12), // Lighter border for a sleek look
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Section with Document Icon and Title
            Row(
              children: [
                // Document Icon on the Left with gradient background
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1), // Subtle color for the background
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent, width: 2), // Blue border
                  ),
                  child: const Icon(
                    Icons.description, // Document icon
                    color: Colors.blueAccent, // Blue icon color
                  ),
                ),
                const SizedBox(width: 16), // Spacing between icon and title
                // Title Text with improved styling
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600, // Slightly lighter font weight
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // Right Section with More Icon
            IconButton(
              icon: const Icon(
                Icons.more_vert_sharp,
                color: Colors.black54, // Lighter color for the more icon
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
