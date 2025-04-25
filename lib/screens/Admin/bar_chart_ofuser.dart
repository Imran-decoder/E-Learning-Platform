import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProgressScreen extends StatefulWidget {
  const UserProgressScreen({super.key});

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
        double progress = totalTasks > 0 ? (completedTasks  / totalTasks) : 0.0;

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
          color: const Color.fromARGB(255, 0, 0, 0), // Change background color here
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
                  ? Center(child: Text("No enrolled courses" , style: TextStyle(color: Colors.white)))
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
                toY: (course['progress'] * 100).roundToDouble(),
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
                return Text(enrolledCourses[value.toInt()]['courseName'].substring(0, 10) + "...",
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
           rightTitles: AxisTitles(
           sideTitles: SideTitles(showTitles: false),  
           ),
    
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              // style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
// Widget _buildBarChart() {
//   return BarChart(
//     BarChartData(
//       maxY: 100,
//       alignment: BarChartAlignment.spaceAround,
//       barTouchData: BarTouchData(
//         enabled: true,
//         touchTooltipData: BarTouchTooltipData(
//           tooltipMargin: 8,
//           getTooltipItem: (group, groupIndex, rod, rodIndex) {
//             final course = enrolledCourses[group.x.toInt()];
//             return BarTooltipItem(
//               "${course['courseName']}\nProgress: ${rod.toY.toInt()}%",
//               const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//           },
//         ),
//       ),
//       barGroups: List.generate(enrolledCourses.length, (index) {
//         final course = enrolledCourses[index];
//         return BarChartGroupData(
//           x: index,
//           barRods: [
//             BarChartRodData(
//               toY: (course['progress'] * 100).roundToDouble(),
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF1C8BE6), Color(0xFF4AD0FF)],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//               width: 16,
//               borderRadius: BorderRadius.circular(4),
//             ),
//           ],
//           showingTooltipIndicators: [0],
//         );
//       }),
//       titlesData: FlTitlesData(
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 35,
//             interval: 20,
//             getTitlesWidget: (value, meta) {
//               return Text(
//                 "${value.toInt()}%",
//                 style: const TextStyle(color: Colors.white, fontSize: 10),
//               );
//             },
//           ),
//         ),
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 70,
//             interval: 1,
//             getTitlesWidget: (value, meta) {
//               String courseName = enrolledCourses[value.toInt()]['courseName'];
//               return Transform.rotate(
//                 angle: -1.5, // Rotate to vertical
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Text(
//                     courseName,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//       gridData: FlGridData(show: true, horizontalInterval: 20),
//       borderData: FlBorderData(show: false),
//     ),
//   );
// }


