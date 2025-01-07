import 'package:flutter/material.dart';
import 'package:elearning/components/dashboard_header.dart';
import 'package:elearning/components/ongoing_course_card.dart';
import 'package:elearning/screens/course_detail_screen.dart';
import 'package:elearning/screens/Admin/admin_dashboard_screen.dart';
import 'package:elearning/components/greeting_section.dart';
import 'package:elearning/components/section_header.dart';
import 'package:elearning/components/course_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchControl = TextEditingController();

  final List<Map<String, String>> courses = [
    {'logo': 'assets/images/icon_1.png', 'name': 'HTML'},
    {'logo': 'assets/images/icon_1.png', 'name': 'CSS'},
    {'logo': 'assets/images/icon_1.png', 'name': 'JavaScript'},
    {'logo': 'assets/images/icon_1.png', 'name': 'React'},
    {'logo': 'assets/images/icon_1.png', 'name': 'Node.js'},
    {'logo': 'assets/images/icon_1.png', 'name': 'Next.js'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with Navbar
          SliverAppBar(
            expandedHeight: 250,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: DashboardHeader(
                animationPath: 'animations/dashboard.json',
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.admin_panel_settings_outlined,
                    color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDashboardScreen(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () => debugPrint("Notifications clicked"),
              ),
              // Remove Search Icon, keep only three dots icon
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () => debugPrint("Menu clicked"),
              ),
            ],
          ),

          // Main body with transparent background and border
          SliverToBoxAdapter(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.transparent, // Transparent background
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1.0,
                  ), // Border around the container
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GreetingSection(userName: "Arshad"),
                    const SizedBox(height: 28),
                    SectionHeader(
                      title: "Explore All Courses",
                      actionText: "See All",
                      onActionTap: () =>
                          debugPrint("See All Courses clicked"),
                    ),
                    const SizedBox(height: 20),
                    CourseList(
                      courses: courses,
                      onCourseTap: (course) =>
                          _onCourseSelected(context, course),
                    ),
                    const SizedBox(height: 28),
                    SectionHeader(
                      title: "Ongoing Course",
                      actionText: "See All",
                      onActionTap: () =>
                          debugPrint("See All Ongoing Courses clicked"),
                    ),
                    const SizedBox(height: 20),
                    OngoingCourseCard(
                        courseName: "Flutter Basics", progress: 0.6),
                    const SizedBox(height: 16),
                    OngoingCourseCard(
                        courseName: "React Native Advanced", progress: 0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
