import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(44, 44, 44, 1),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(  // Wrap the content with SingleChildScrollView
          padding: const EdgeInsets.only(bottom: 100), // Add padding to avoid hiding behind navbar
          child: Padding(
            padding: const EdgeInsets.only(top: 42.0, left: 18.0, right: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader('Admin'),
                const SizedBox(height: 16),
                _buildPersonTile("Admin", isAdmin: true),
                const SizedBox(height: 32),

                _buildSectionHeader('New User Requests'),
                _buildNewUserRequests(context),
                const SizedBox(height: 32),

                _buildSectionHeader('Classmates'),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Users').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No classmates found.",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final students = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,  // Make the listview not take up all available space
                      physics: NeverScrollableScrollPhysics(),  // Disable scrolling on ListView
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        final name = student['Profile']?['main']?['firstName'] ?? "Unknown";
                        final userId = student['userName'];
                        return _buildPersonTile(name, userId: userId);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build the header text with gradient effect
// Function to build the header text with gradient effect
  Widget _buildHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),  // Added padding for spacing
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),  // Rounded corners for a softer look
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,  // Larger font size for prominence
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',  // Add a modern font
          letterSpacing: 2,  // Slight spacing between letters for clarity
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 128),
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }


  // Function to build the section header text
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Function to build the "New User Requests" section with static data
  Widget _buildNewUserRequests(BuildContext context) {
    final dummyRequests = [
      {"name": "John Doe", "user_id": "user123"},
      {"name": "Jane Smith", "user_id": "user456"},
      {"name": "Sam Wilson", "user_id": "user789"},
      {"name": "Chris Johnson", "user_id": "user234"},
      {"name": "Emma Watson", "user_id": "user567"},
    ];

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: dummyRequests.length,
        itemBuilder: (context, index) {
          final request = dummyRequests[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildRequestTile(context, request['name']!, request['user_id']!),
          );
        },
      ),
    );
  }

  // Function to build the "Request Tile" with approval/rejection buttons
  Widget _buildRequestTile(BuildContext context, String name, String userId) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonTile(name, userId: userId),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Approve Button
                _buildActionButton(
                  context,
                  'Approve',
                  Colors.green,
                      () {
                    print("Approved $name");
                  },
                ),
                const SizedBox(width: 8),
                // Reject Button
                _buildActionButton(
                  context,
                  'Reject',
                  Colors.red,
                      () {
                    print("Rejected $name");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable action button
  Widget _buildActionButton(
      BuildContext context, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  // Widget to build the person tile
  Widget _buildPersonTile(String name, {String? userId, bool isAdmin = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isAdmin ? Colors.tealAccent : Colors.grey[800],
        child: Icon(
          isAdmin ? Icons.person : Icons.person_outline,
          color: Colors.black,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: userId != null
          ? Text(
        userId,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      )
          : null,
    );
  }
}
