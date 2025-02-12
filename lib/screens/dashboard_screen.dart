import 'package:elearning/screens/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    super.key,
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userName = "User";

  Future<bool> checkUserAdmin(String userID) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .get();

      return documentSnapshot.exists &&
          documentSnapshot.data() != null &&
          documentSnapshot['isAdmin'] == true;
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }

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

        // Retrieve FCM token
        final fcmToken = await FirebaseMessaging.instance.getToken();

        // Store user name and FCM token in Firestore
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set(
          {
            'Profile': {
              'main': {
                'firstName': firstName ?? 'User',
              },
            },
            'fcm_token': fcmToken, // Store FCM token here
          },
          SetOptions(merge: true), // Merge to update existing data
        );

        setState(() {
          _userName = firstName ?? "User";
        });
      }
    } catch (e) {
      debugPrint("Error fetching user name: $e");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchEnrolledCourses() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final QuerySnapshot enrolledCoursesSnapshot = await FirebaseFirestore
            .instance
            .collection('Users')
            .doc(user.uid)
            .collection('enrolledCourses')
            .get();

        List<Map<String, dynamic>> enrolledCourses = [];

        for (var doc in enrolledCoursesSnapshot.docs) {
          String courseId = doc.id;
          Map<String, dynamic> enrolledCourseData =
              doc.data() as Map<String, dynamic>;

          // Extract tasks from user collection
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

            enrolledCourses.add({
              'courseId': courseId,
              'courseName': courseData['title']?.toString() ?? 'Unnamed Course',
              'progress': progress, // Calculated progress
            });

            // Debugging prints
            // print('Course ID: $courseId');
           //  print('Tasks: $tasks');
            // print('Total tasks: $totalTasks');
            // print('Completed tasks: $completedTasks');
            //print('Progress: ${progress * 100}%');
          }
        }
        return enrolledCourses;
      }
    } catch (e) {
      debugPrint('Error fetching enrolled courses: $e');
    }
    return [];
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
      pinned: false,
      // Allows the app bar to collapse on scroll
      floating: false,
      expandedHeight: 300,
      // Adjust height as needed
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
                padding: MediaQuery.of(context).size.width < 600
                    ? const EdgeInsets.only(
                        top: 50) // Adjust padding for mobile
                    : const EdgeInsets.only(
                        top: 20), // Adjust padding for larger screens
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
                    fontSize: screenWidth < 600 ? 20 : 28, // Scale font size
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 9.0, // Softness of the shadow
                        color: Colors.black.withOpacity(1), // Shadow color
                        offset: Offset(2, 2), // X and Y offset
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
            onPressed: () async {
              final userID = FirebaseAuth.instance.currentUser!.uid;
              if (await checkUserAdmin(userID)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDashboardScreen(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You are not an admin')),
                );
              }
            }),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationScreen(),
              ),
            );
          },
        ),
        // IconButton(
        //   icon: const Icon(Icons.more_vert, color: Colors.white),
        //   onPressed: () => debugPrint("Menu clicked"),
        // ),
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
                  onActionTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Srcoll Right to see all courses.")),
                  ),
                ),
                const SizedBox(height: 20),
                _buildCoursesList(),
                const SizedBox(height: 28),
                _buildSectionHeader(
                  title: "Ongoing Course",
                  actionText: "See All",
                  onActionTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Scroll down to see all enrolled courses.")),
                  ),
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

  // Widget _buildOngoingCourses() {

  //   return Column(
  //     children: const [
  //       OngoingCourseCard(courseName: "Flutter Basics", progress: 0.6),
  //       SizedBox(height: 16),
  //       OngoingCourseCard(courseName: "React Native Advanced", progress: 0.3),
  //     ],
  //   );
  // }

  Widget _buildOngoingCourses() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchEnrolledCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error loading ongoing courses: ${snapshot.error}"),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No ongoing courses available."));
        }

        return Column(
          children: snapshot.data!.map((course) {
            return Column(
              children: [
                OngoingCourseCard(
                  courseName: course['courseName'],
                  progress: course['progress'],
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  void _onCourseSelected(BuildContext context, Map<String, String> course) async {
  final String courseId = course['id'] ?? '';
  final userID = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;

  if (courseId.isNotEmpty) {
    try {
      // Check if the user is enrolled in the course.
      final enrollmentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .collection('enrolledCourses')
          .doc(courseId)
          .get();

      if (enrollmentSnapshot.exists) {
        // User is enrolled: navigate to the course details screen.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CourseDetailsScreen(courseId: courseId, userId: userID),
          ),
        );
      } else {
        // Check if a request for this course already exists.
        final requestSnapshot = await FirebaseFirestore.instance
            .collection('requests')
            .where('userId', isEqualTo: userID)
            .where('courseId', isEqualTo: courseId)
            .where('allotted', isEqualTo: false)
            .get();

        if (requestSnapshot.docs.isNotEmpty) {
          // A request already exists.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "You have already sent a request for this course. Please wait for admin response.",
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        } else {
          // No enrollment and no existing request: prompt to send a new request.
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Request Enrollment"),
                content: Text(
                    "You are not enrolled in this course. Would you like to send a request to the admin for enrollment?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog.
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Save the enrollment request.
                      await FirebaseFirestore.instance.collection('requests').add({
                        'userId': userID,
                        'courseId': courseId,
                        'allotted': false, // initially set to false.
                        'timestamp': FieldValue.serverTimestamp(),
                        'email': email,
                      });
                      Navigator.of(context).pop(); // Dismiss the dialog.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Request sent to admin.")),
                      );
                    },
                    child: Text("Send Request"),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      debugPrint("Error checking enrollment status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "An error occurred while checking enrollment status. Please try again."),
        ),
      );
    }
  } else {
    debugPrint("Course ID is missing.");
  }
}

}
