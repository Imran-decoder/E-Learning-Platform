import 'package:flutter/material.dart';
import 'package:elearning/components/ongoing_course_card.dart';
import 'package:elearning/components/explore_course_card.dart';

class DashboardScreen extends StatefulWidget {
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.png'),
                  radius: 22,
                ),
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.notifications, size: 30.0, color: Colors.white),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.grey),
                      onPressed: () {
                        debugPrint("Menu clicked");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Hello, Arshad!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Search Bar
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                controller: _searchControl,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search courses",
                                  hintStyle: TextStyle(color: Colors.white70, fontSize: 18.0),
                                ),
                                style: TextStyle(color: Colors.white70, fontSize: 21.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Icon(Icons.search, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  // Explore All Courses Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Explore All Courses",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Explore Courses Carousel
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return ExploreCourseCard(
                          logoPath: courses[index]['logo']!,
                          courseName: courses[index]['name']!,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 28),
                  // Ongoing Courses Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Ongoing Course",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Ongoing Courses
                  OngoingCourseCard(courseName: "Flutter Basics", progress: 0.6),
                  SizedBox(height: 16),
                  OngoingCourseCard(courseName: "React Native Advanced", progress: 0.3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
