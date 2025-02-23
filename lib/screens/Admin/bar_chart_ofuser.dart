import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProgressScreen extends StatefulWidget {
  @override
  _UserProgressScreenState createState() => _UserProgressScreenState();
}

class _UserProgressScreenState extends State<UserProgressScreen> {
  String? selectedUserId;
  List<Map<String, dynamic>> enrolledCourses = [];

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      return userSnapshot.docs.map((doc) {
        return {'id': doc.id, 'name': doc['Profile']['main']['firstName']};
      }).toList();
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }

  Future<void> _fetchEnrolledCourses(String userId) async {
    try {
      QuerySnapshot enrolledCoursesSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('enrolledCourses')
          .get();

      List<Map<String, dynamic>> courses = [];

      for (var doc in enrolledCoursesSnapshot.docs) {
        String courseId = doc.id;
        Map<String, dynamic> enrolledCourseData =
            doc.data() as Map<String, dynamic>;

        // Extract tasks
        Map<String, dynamic> tasks = enrolledCourseData['tasks'] ?? {};
        int totalTasks = tasks.length;
        int completedTasks =
            tasks.values.where((value) => value == true).length;
        double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

        // Fetch course details from 'Courses' collection
        DocumentSnapshot courseDoc = await FirebaseFirestore.instance
            .collection('Courses')
            .doc(courseId)
            .get();

        if (courseDoc.exists) {
          Map<String, dynamic> courseData =
              courseDoc.data() as Map<String, dynamic>;

          courses.add({
            'courseId': courseId,
            'courseName': courseData['title']?.toString() ?? 'Unnamed Course',
            'progress': progress,
          });
        }
      }

      setState(() {
        enrolledCourses = courses;
      });
    } catch (e) {
      debugPrint('Error fetching enrolled courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("User Progress")),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[900], // Change background color here
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchUsers(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  List<Map<String, dynamic>> users = snapshot.data!;
                  return DropdownButton<String>(
                    hint: Text("Select User", style: TextStyle(color: Colors.white)),
                    dropdownColor: Colors.blueGrey[800],
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    iconSize: 24,
                    isExpanded: true,
                    style: TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    value: selectedUserId,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUserId = newValue;
                        enrolledCourses = [];
                      });
                      if (newValue != null) {
                        _fetchEnrolledCourses(newValue);
                      }
                    },
                    items: users.map((user) {
                      return DropdownMenuItem<String>(
                        value: user['id'],
                        child: Text(user['name']),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 20),
              enrolledCourses.isEmpty
                  ? Center(child: Text("No enrolled courses"))
                  : Expanded(child: _buildBarChart()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: enrolledCourses.map((course) {
          return BarChartGroupData(
            x: enrolledCourses.indexOf(course),
            barRods: [
              BarChartRodData(
                toY: course['progress'] * 100,
                color: const Color.fromARGB(255, 28, 139, 230),
                width: 15,
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(enrolledCourses[value.toInt()]['courseName'],
                    style: TextStyle(fontSize: 10, color: Colors.white));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text("${value.toInt()}%", style: TextStyle(color: Colors.white));
              },
            ),
          ),
        ),
      ),
    );
  }
}
