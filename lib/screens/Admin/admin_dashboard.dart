import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:elearning/screens/Admin/bar_chart_ofuser.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard"),
       titleTextStyle: const TextStyle(color: Colors.white , fontSize: 20, fontWeight: FontWeight.bold), 
       ),
    body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      color: const Color.fromARGB(255, 22, 33, 75),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Container(color: Color(0xff4caf50), height: 50, width: 50),
            const SizedBox(height: 20),
            const Text(
              "Course Task Distribution",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
                    SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    // Glass effect background
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width < 600
                            ? double.infinity
                            : double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    // Pie Chart Widget
                    CoursePieChart(),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: Stack(
                children: [
                  // Glass effect background
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  // Bar Chart Widget
                  UserProgressScreen(),
                ],
              ),
            ),
            const SizedBox(height: 65),

          ],
        ),
      ),
    ),
    );
  }
}


class CoursePieChart extends StatefulWidget {
  const CoursePieChart({super.key});

  @override
  _CoursePieChartState createState() => _CoursePieChartState();
}

class _CoursePieChartState extends State<CoursePieChart> {
  Map<String, int> courseTaskCounts = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTaskData();
  }

  Future<void> fetchTaskData() async {
    try {
      QuerySnapshot coursesSnapshot =
          await FirebaseFirestore.instance.collection('Courses').get();

      Map<String, int> tempCounts = {};

      for (var course in coursesSnapshot.docs) {
        String courseId = course.id;
        String courseName = course['title']; // Assuming course has a title

        QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
            .collection('Courses')
            .doc(courseId)
            .collection('tasks')
            .get();

        tempCounts[courseName] = taskSnapshot.size;
      }

      setState(() {
        courseTaskCounts = tempCounts;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (courseTaskCounts.isEmpty) {
      return const Center(child: Text("No course data available"));
    }

    int totalTasks = courseTaskCounts.values.fold(0, (sum, count) => sum + count);

return Column(
  children: [
    Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sections: _generateChartSections(totalTasks),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildLegend(),
        ],
      ),
    ),
  ],
);
  }

  List<PieChartSectionData> _generateChartSections(int totalTasks) {
    return courseTaskCounts.entries.map((entry) {
      double percentage = (entry.value / totalTasks) * 100;
      double radius = MediaQuery.of(context).size.width < 600 ? 60 : 70;
      return PieChartSectionData(
        color: _getRandomColor(entry.key),
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Column(
      children: courseTaskCounts.keys.map((courseName) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 16, height: 16, color: _getRandomColor(courseName)),
            const SizedBox(width: 8),
            Text(courseName, style: const TextStyle(fontSize: 14, color: Colors.white)),
          ],
        );
      }).toList(),
    );
  }

  Color _getRandomColor(String key) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.teal,
      // Colors.pink,      
    ];
    return colors[key.hashCode % colors.length];
  }
}