import 'package:elearning/screens/Admin/admin_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:elearning/components/ongoing_course_card.dart';
import 'package:elearning/components/explore_course_card.dart';
import 'package:elearning/screens/course_detail_screen.dart';
import 'package:elearning/screens/admin_screen.dart'; // Import the AdminScreen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchControl = TextEditingController();
  late FocusNode myFocusNode;

  final List<Map<String, String>> courses = [
    {'logo': 'assets/images/profile.png', 'name': 'HTML'},
    {'logo': 'assets/images/blob_1.png', 'name': 'CSS'},
    {'logo': 'assets/images/blob_2.png', 'name': 'JavaScript'},
    {'logo': 'assets/images/icon_1.png', 'name': 'React'},
    {'logo': 'assets/images/icon_2.png', 'name': 'Node.js'},
    {'logo': 'assets/images/icon_3.png', 'name': 'Next.js'},
  ];

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchControl.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              _buildGreetingSection(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 28),
              _buildSectionHeader(
                title: "Explore All Courses",
                actionText: "See All",
              ),
              const SizedBox(height: 20),
              _buildCourseList(
                courses,
                    (index) => ExploreCourseCard(
                  logoPath: courses[index]['logo']!,
                  courseName: courses[index]['name']!,
                  onTap: () => _onCourseSelected(context, courses[index]),
                ),
              ),
              const SizedBox(height: 28),
              _buildSectionHeader(
                title: "Ongoing Course",
                actionText: "See All",
              ),
              const SizedBox(height: 20),
              ..._buildOngoingCourses(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.black),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications, size: 30.0, color: Colors.black45),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onPressed: () => debugPrint("Menu clicked"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return const Center(
      child: Text(
        "Hello, Arshad!",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchControl,
                  decoration: const InputDecoration(
                    fillColor: Colors.deepOrange,
                    border: InputBorder.none,
                    hintText: "Search courses",
                    hintStyle: TextStyle(color: Colors.white70, fontSize: 18.0),
                  ),
                  style: const TextStyle(color: Colors.black54, fontSize: 21.0),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(Icons.search, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String actionText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          actionText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseList(List<Map<String, String>> courses, Widget Function(int) itemBuilder) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) => itemBuilder(index),
      ),
    );
  }

  List<Widget> _buildOngoingCourses() {
    return [
      OngoingCourseCard(courseName: "Flutter Basics", progress: 0.6),
      const SizedBox(height: 16),
      OngoingCourseCard(courseName: "React Native Advanced", progress: 0.3),
    ];
  }

  void _onCourseSelected(BuildContext context, Map<String, String> course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailsScreen(
          courseName: course['name']!,
        ),
      ),
    );
  }
}
