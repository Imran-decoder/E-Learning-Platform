import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning/components/Admin/custom_dialog.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(44, 44, 44, 1),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 42.0, left: 18.0, right: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Admin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildPersonTile("Admin", isAdmin: true),
              const SizedBox(height: 16),

              // New User Requests Section
              const Text(
                "New User Requests",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildNewUserRequests(context),
              const SizedBox(height: 16),

              // Classmates Section
              const Text(
                "Classmates",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Students').snapshots(),
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
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        final name = student['name'] ?? "Unknown";
                        final userId = student['user_id'];
                        return _buildPersonTile(name, userId: userId);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
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
      height: 250, // Increased height for better visibility
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[950],
        borderRadius: BorderRadius.circular(12),
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

  // Function to build the "Request Tile" with approval/rejection buttons for static data
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
                ElevatedButton(
                  onPressed: () {
                    // Handle approval logic here (e.g., update data or show confirmation)
                    print("Approved $name");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Corrected to backgroundColor
                  ),
                  child: const Text('Approve', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                // Reject Button
                ElevatedButton(
                  onPressed: () {
                    // Handle rejection logic here (e.g., update data or show confirmation)
                    print("Rejected $name");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Corrected to backgroundColor
                  ),
                  child: const Text('Reject', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to display the custom dialog when tapping on a request
  void _showRequestDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'User Request: $name',
        content: 'Do you want to approve the request of $name?',
        actions: [
          TextButton(
            onPressed: () {
              // Handle the approval action
              Navigator.of(context).pop();
            },
            child: const Text('Approve', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              // Handle the rejection action
              Navigator.of(context).pop();
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
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
