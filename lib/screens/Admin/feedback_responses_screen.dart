import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FeedbackResponsesScreen extends StatefulWidget {
  const FeedbackResponsesScreen({super.key});

  @override
  State<FeedbackResponsesScreen> createState() =>
      _FeedbackResponsesScreenState();
}

class _FeedbackResponsesScreenState extends State<FeedbackResponsesScreen> {
  String _searchQuery = '';
  List<DocumentSnapshot> _allUsers = [];
  List<DocumentSnapshot> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('Users')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _allUsers = snapshot.docs;
        _filterUsers();
      });
    });
  }

  void _filterUsers() {
    if (_searchQuery.isEmpty) {
      _filteredUsers = _allUsers;
    } else {
      _filteredUsers = _allUsers.where((doc) {
        final name = (doc.data() as Map?)?['Profile']?['main']?['firstName']
                ?.toString()
                .toLowerCase() ??
            '';
        return name.contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Feedback Responses'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.grey[900],
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _filterUsers();
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search users...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[850],
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            Expanded(
              child: _filteredUsers.isEmpty
                  ? const Center(
                      child: Text("No users found",
                          style: TextStyle(color: Colors.white70)))
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 12,
                        bottom: MediaQuery.of(context).padding.bottom +
                            80, // Adds extra space at bottom
                      ),
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        var userDoc = _filteredUsers[index];
                        var userData = userDoc.data() as Map<String, dynamic>?;
                        String userName = userData?['Profile']?['main']
                                ?['firstName'] ??
                            'Unknown';

                        return Card(
                          color: Colors.grey[850],
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text(userName,
                                style: const TextStyle(color: Colors.white)),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white54, size: 18),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserFeedbackScreen(
                                      userId: userDoc.id, userName: userName),
                                ),
                              );
                            },
                          ),
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

class UserFeedbackScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const UserFeedbackScreen(
      {super.key, required this.userId, required this.userName});

  @override
  State<UserFeedbackScreen> createState() => _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends State<UserFeedbackScreen> {
  String selectedCourseId = 'All';
  List<String> courseIds = ['All'];
  Map<String, String> courseTitles = {};

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Courses').get();
    for (var doc in snapshot.docs) {
      courseIds.add(doc.id);
      courseTitles[doc.id] = doc.data()['title'] ?? 'Unknown';
    }
    setState(() {});
  }

  Future<void> exportFeedbackToCSV(
      List<QueryDocumentSnapshot> feedbackDocs) async {
    List<List<dynamic>> csvData = [
      ['Course Title', 'Feedback Key', 'Feedback Value', 'Rating'],
    ];

    for (var doc in feedbackDocs) {
      var data = doc.data() as Map<String, dynamic>;
      String title = courseTitles[doc.id] ?? 'Unknown Course';

      for (var entry in data.entries) {
        if (entry.key != 'rating' && entry.key != 'timestamp') {
          csvData.add([title, entry.key, entry.value, data['rating'] ?? '']);
        }
      }
    }

    String csv = const ListToCsvConverter().convert(csvData);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/feedback_${widget.userName}.csv');
    await file.writeAsString(csv);
    await Share.shareXFiles([XFile(file.path)], text: 'Exported Feedback CSV');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("${widget.userName}'s Feedback"),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () async {
              var snapshot = await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(widget.userId)
                  .collection('feedback')
                  .get();
              await exportFeedbackToCSV(snapshot.docs);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: DropdownButtonFormField<String>(
                value: selectedCourseId,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                items: courseIds.map((id) {
                  return DropdownMenuItem<String>(
                    value: id,
                    child: Text(id == 'All'
                        ? 'All Courses'
                        : courseTitles[id] ?? 'Unknown'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCourseId = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(widget.userId)
                    .collection('feedback')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No feedback found.',
                          style: TextStyle(color: Colors.white70)),
                    );
                  }

                  var feedbackDocs = snapshot.data!.docs;
                  if (selectedCourseId != 'All') {
                    feedbackDocs = feedbackDocs
                        .where((doc) => doc.id == selectedCourseId)
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: feedbackDocs.length,
                    itemBuilder: (context, index) {
                      var feedback = feedbackDocs[index];
                      var data = feedback.data() as Map<String, dynamic>;

                      return Card(
                        color: Colors.grey[850],
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                courseTitles[feedback.id] ?? 'Course',
                                style: const TextStyle(
                                    color: Colors.tealAccent,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Divider(color: Colors.white24),
                              ...data.entries
                                  .where((e) =>
                                      e.key != 'rating' && e.key != 'timestamp')
                                  .map((entry) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    '${entry.key}: ${entry.value}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }),
                              const Divider(color: Colors.white24),
                              Text(
                                '⭐ Rating: ${data['rating'] ?? 'N/A'}',
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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
