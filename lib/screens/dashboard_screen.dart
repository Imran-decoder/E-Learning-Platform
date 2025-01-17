import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elearning/components/dashboard_header.dart';
import 'package:elearning/components/ongoing_course_card.dart';
import 'package:elearning/screens/course_detail_screen.dart';
import 'package:elearning/screens/Admin/admin_dashboard_screen.dart';
import 'package:elearning/components/greeting_section.dart';
import 'package:elearning/components/section_header.dart';
import 'package:elearning/components/course_list.dart';

// GradientText Widget with dynamic font scaling
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width to adjust font size dynamically
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust font size based on screen width
    double fontSize = screenWidth < 600
        ? 20
        : 28; // Smaller for mobile, larger for tablets/desktops

    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style: style?.copyWith(
              color: Colors.white,
              fontSize: fontSize, // Dynamically adjusted font size
            ) ??
            TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchControl = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userName = "User";

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        final firstName = userDoc['Profile']['main']['firstName'];

        setState(() {
          _userName = firstName ?? "User";
        });
      }
    } catch (e) {
      debugPrint("Error fetching user name: $e");
    }
  }

  Future<List<Map<String, String>>> _fetchCourses() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Courses').get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'logo': (doc['logo']?.toString().isNotEmpty == true &&
                  Uri.tryParse(doc['logo'].toString())?.isAbsolute == true)
              ? doc['logo'].toString()
              : 'assets/images/default_logo.webp',
          'name': doc['title']?.toString() ?? 'Unnamed Course',
        };
      }).toList();
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return SliverAppBar(
      pinned: false, // Allows the app bar to collapse on scroll
      floating: false,
      expandedHeight: 300, // Adjust height as needed
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background animation or image
            const DashboardHeader(
              animationPath: 'animations/dashboard.json',
            ),

            // Overlay text at the top of the image
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width < 600
                          ? 50.0
                          : 40.0),
                  child: GradientText(
                    'THE FIRE VALA',
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange,
                        Colors.red,
                        Colors.white,
                        Colors.blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width < 600
                          ? 20
                          : 28, // Scale font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ],
        ),
      ),
      leading: IconButton(
        icon: Image.asset('assets/images/splash.png'),
        onPressed: () {
          Navigator.pop(context);
        },
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
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () => debugPrint("Menu clicked"),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SliverToBoxAdapter(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetingSection(userName: _userName),
                const SizedBox(height: 28),
                _buildSectionHeader(
                  title: "Explore All Courses",
                  actionText: "See All",
                  onActionTap: () => debugPrint("See All Courses clicked"),
                ),
                const SizedBox(height: 20),
                _buildCoursesList(),
                const SizedBox(height: 28),
                _buildSectionHeader(
                  title: "Ongoing Course",
                  actionText: "See All",
                  onActionTap: () =>
                      debugPrint("See All Ongoing Courses clicked"),
                ),
                const SizedBox(height: 20),
                _buildOngoingCourses(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionText,
    required VoidCallback onActionTap,
  }) {
    return SectionHeader(
      title: title,
      actionText: actionText,
      onActionTap: onActionTap,
    );
  }

  Widget _buildCoursesList() {
    return FutureBuilder<List<Map<String, String>>>(
      future: _fetchCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error loading courses: ${snapshot.error}"),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No courses available."));
        }

        return CourseList(
          courses: snapshot.data!,
          onCourseTap: (course) => _onCourseSelected(context, course),
        );
      },
    );
  }

  Widget _buildOngoingCourses() {
    return Column(
      children: const [
        OngoingCourseCard(courseName: "Flutter Basics", progress: 0.6),
        SizedBox(height: 16),
        OngoingCourseCard(courseName: "React Native Advanced", progress: 0.3),
      ],
    );
  }

  void _onCourseSelected(BuildContext context, Map<String, String> course) {
    final String courseId = course['id'] ?? '';
    if (courseId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CourseDetailsScreen(courseId: courseId),
        ),
      );
    } else {
      debugPrint("Course ID is missing.");
    }
  }
}
