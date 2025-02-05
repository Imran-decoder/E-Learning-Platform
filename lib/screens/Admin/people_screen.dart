import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning/components/Admin/custom_dialog.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(44, 44, 44, 1),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 42.0, left: 18.0, right: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Section
              const Text(
                "Admin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .where('isAdmin', isEqualTo: true) // Fetch only admins
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No admins found.", style: TextStyle(color: Colors.white)),
                      );
                    }
                    final admins = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: admins.length,
                      itemBuilder: (context, index) {
                        final admin = admins[index];
                        final name = admin['Profile']?['main']?['firstName'] ?? "Unknown";
                        final username = admin['userName'] ?? "No username";
                        return _buildPersonTile(name, username: username, isAdmin: true);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // New User Requests Section (only pending requests)
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
              // Classmates Section (Non-admin users)
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
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .where('isAdmin', isEqualTo: false) // Fetch only non-admins
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No classmates found.", style: TextStyle(color: Colors.white)),
                      );
                    }
                    final students = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        final name = student['Profile']?['main']?['firstName'] ?? "Unknown";
                        final username = student['userName'] ?? "No username";
                        final userId = student.id;
                        return GestureDetector(
                          onTap: () => _showRequestDialog(context, name, userId),
                          child: _buildPersonTile(name, username: username),
                        );
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

  /// Builds the "New User Requests" section using real-time Firestore data.
  Widget _buildNewUserRequests(BuildContext context) {
    return Container(
      height: 250, // Increased height for better visibility
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[950],
        borderRadius: BorderRadius.circular(12),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('allotted', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.white)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final requestDocs = snapshot.data?.docs ?? [];
          if (requestDocs.isEmpty) {
            return const Center(child: Text("No requests found.", style: TextStyle(color: Colors.white)));
          }
          return ListView.builder(
            itemCount: requestDocs.length,
            itemBuilder: (context, index) {
              // Get document data and id.
              final doc = requestDocs[index];
              final data = doc.data() as Map<String, dynamic>;
              final String userId = data['userId'] ?? 'Unknown';
              final String courseId = data['courseId'] ?? 'Unknown';
              final String email = data['email'] ?? 'Unknown';
              final bool allotted = data['allotted'] ?? false;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildRequestTile(context, doc.id, userId, courseId, allotted, email),
              );
            },
          );
        },
      ),
    );
  }

Future<void> enrollUserInCourse(String userId, String courseId) async {
  try {
    // Fetch all task documents from the 'tasks' subcollection under the course.
    final tasksSnapshot = await FirebaseFirestore.instance
        .collection('Courses')
        .doc(courseId)
        .collection('tasks')
        .get();

    if (tasksSnapshot.docs.isEmpty) {
      throw 'No tasks found for the course.';
    }

    // Build a map where each task ID is set to false.
    final Map<String, dynamic> tasksMap = {};
    for (var taskDoc in tasksSnapshot.docs) {
      tasksMap[taskDoc.id] = false; // Initialize each task as false.
    }

    // Create or update the enrolled course document under the user's subcollection.
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('enrolledCourses')
        .doc(courseId)
        .set({
      'tasks': tasksMap,
    });
  } catch (e) {
    throw 'Failed to enroll in course: $e';
  }
}

Widget _buildRequestTile(BuildContext context, String requestId, String userId, String courseId, bool allotted, String email) {
  return FutureBuilder<Map<String, String>>(
    future: _getUserAndCourseInfo(userId, courseId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
      }
      final data = snapshot.data!;
      final username = data['username']!;
      final courseTitle = data['courseTitle']!;
      // Use the email passed in, not from data.
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
              // Display the username from the Users collection.
              _buildPersonRequestTile(username, email, username: username),
              const SizedBox(height: 4),
              // Display the course title from the Courses collection.
              Text(
                "Course: $courseTitle",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await enrollUserInCourse(userId, courseId);
                        await FirebaseFirestore.instance
                            .collection('requests')
                            .doc(requestId)
                            .update({'allotted': true});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Request approved and user enrolled.")),
                        );
                      } catch (e) {
                        print("Error approving request: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error approving request.")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Approve', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('requests')
                            .doc(requestId)
                            .delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Request rejected.")),
                        );
                      } catch (e) {
                        print("Error rejecting request: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error rejecting request.")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Reject', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


  /// Helper method that fetches the username and course title based on the userId and courseId.
  /// It assumes that the Users document has a 'userName' field and
  /// the Courses document has a 'title' field.
Future<Map<String, String>> _getUserAndCourseInfo(String userId, String courseId) async {
  final userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
  final courseDoc = await FirebaseFirestore.instance.collection('Courses').doc(courseId).get();
  final username = userDoc.exists ? (userDoc.data()?['userName'] ?? 'Unknown User') : 'Unknown User';
  final courseTitle = courseDoc.exists ? (courseDoc.data()?['title'] ?? 'Unknown Course') : 'Unknown Course';
  final email = userDoc.exists ? (userDoc.data()?['email'] ?? 'Unknown Email') : 'Unknown Email';
  return {'username': username, 'courseTitle': courseTitle, 'email': email};
}

  /// Displays a custom dialog when a classmate tile is tapped,
  /// asking the admin whether to promote the user to admin.
  void _showRequestDialog(BuildContext context, String name, String userId) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'User Request: $name',
        content: 'Do you want to promote $name to Admin?',
        actions: [
          TextButton(
            onPressed: () async {
              try {
                // Update the user's document to set isAdmin to true.
                await FirebaseFirestore.instance.collection('Users').doc(userId).update({
                  'isAdmin': true,
                });
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User promoted to admin.")),
                );
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Error promoting user.")),
                );
              }
            },
            child: const Text('Promote', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cancel and close the dialog
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Builds a person tile that shows a user's name and username.
  Widget _buildPersonTile(String name, {required String username, bool isAdmin = false}) {
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
      subtitle: Text(
        username,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }
   /// Builds a person tile that shows a user's username and email.
  Widget _buildPersonRequestTile(String name, String email, {required String username, bool isAdmin = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isAdmin ? Colors.tealAccent : Colors.grey[800],
        child: Icon(
          isAdmin ? Icons.person : Icons.person_outline,
          color: Colors.black,
        ),
      ),
      title: Text(
        username,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        email,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }
}
