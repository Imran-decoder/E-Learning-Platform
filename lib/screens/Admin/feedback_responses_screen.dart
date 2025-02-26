import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackResponsesScreen extends StatelessWidget {
  const FeedbackResponsesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Feedback Responses'),
        titleTextStyle: const TextStyle(color: Colors.white , fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.grey[900],
        elevation: 4,
        shadowColor: Colors.white24,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No feedback responses available.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 12,
                      bottom: MediaQuery.of(context).padding.bottom + 100, // Extra bottom padding
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var userDoc = snapshot.data!.docs[index];
                      var userData = userDoc.data() as Map<String, dynamic>?;
                      String userName = userData?['Profile']?['main']?['firstName'] ?? 'Unknown User';

                      return Card(
                        color: Colors.grey[850]?.withOpacity(0.9),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          title: Text(userName, style: const TextStyle(color: Colors.white, fontSize: 18)),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserFeedbackScreen(userId: userDoc.id, userName: userName),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserFeedbackScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const UserFeedbackScreen({super.key, required this.userId, required this.userName});

  Future<String> fetchCourseTitle(String courseId) async {
    try {
      var courseDoc = await FirebaseFirestore.instance.collection('Courses').doc(courseId).get();
      return courseDoc.data()?['title'] ?? 'Unknown Course';
    } catch (e) {
      return 'Unknown Course';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("$userName's Feedback"),
        titleTextStyle: const TextStyle(color: Colors.white , fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.grey[900],
        elevation: 4,
        shadowColor: Colors.white24,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Users').doc(userId).collection('feedback').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No feedback responses from this user.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 12,
                      bottom: MediaQuery.of(context).viewPadding.bottom + 80,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var feedbackDoc = snapshot.data!.docs[index];
                      var feedbackData = feedbackDoc.data() as Map<String, dynamic>?;
                      if (feedbackData == null) return const SizedBox.shrink();
                      String courseId = feedbackDoc.id;

                      return FutureBuilder<String>(
                        future: fetchCourseTitle(courseId),
                        builder: (context, courseSnapshot) {
                          String courseTitle = courseSnapshot.data ?? 'Fetching Course...';

                          return Card(
                            color: Colors.grey[850]?.withOpacity(0.9),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    courseTitle,
                                    style: const TextStyle(color: Colors.tealAccent, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  const Divider(color: Colors.white24),
                                  ...feedbackData.entries.map((entry) {
                                    if (entry.key != 'rating' && entry.key != 'timestamp') {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Text(
                                          '${entry.key}: ${entry.value}',
                                          style: const TextStyle(color: Colors.white, fontSize: 16),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }),
                                  const Divider(color: Colors.white24),
                                  Text(
                                    '⭐ Rating: ${feedbackData['rating'] ?? 'N/A'}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
