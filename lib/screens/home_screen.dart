import 'package:elearning/screens/category_screen.dart';
import 'package:elearning/utils/const.dart';
import 'package:elearning/widgets/card_courses.dart';
import 'package:elearning/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchControl = TextEditingController();
  late FocusNode myFocusNode;

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
        preferredSize: Size(double.infinity, 100),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Constants.mainPadding,
                  vertical: Constants.mainPadding,
                ),
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(255,255,255,0.3),
                  image: DecorationImage(
                    image: AssetImage("assets/icons/profile.png"),
                    fit: BoxFit.cover,
                  )
                ),
              ),
              //Menu Button
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Constants.mainPadding,
                  vertical: Constants.mainPadding,
                ),
                height: 44,
                width: 44,
                child: TextButton(
                  onPressed: () {
                    debugPrint("Menu pressed");
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Icon(Icons.menu, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Header(),
          Padding(
            padding: EdgeInsets.all(Constants.mainPadding),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                SizedBox(height: Constants.mainPadding * 2),
                Text(
                  "Welcome back\nStudent!",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Constants.mainPadding),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: TextField(
                    focusNode: myFocusNode,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Constants.textDark,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(22.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintText: "Search courses",
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Constants.textDark,
                        ),
                        onPressed: () {
                          debugPrint("Search pressed");
                        },
                      ),
                      hintStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    maxLines: 1,
                    controller: _searchControl,
                  ),
                ),
                SizedBox(height: Constants.mainPadding),
                Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xFFFEF3F3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Start Learning \nNew Stuff!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Constants.textDark,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            width: 150,
                            child: TextButton(
                              onPressed: () {
                                debugPrint("Pressed here");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Constants.salmonMain,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Categories",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        "assets/images/researching.png",
                        width: 200,
                        height: 104,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  "Courses in progress",
                  style: TextStyle(
                    color: Constants.textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                ListView(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    // Replace this with your CardCourses widget
                    CardCourses(
                      image: Image.asset("assets/images/icon_1.png", width: 40, height: 40),
                      color: Constants.lightPink,
                      title: "Adobe XD Prototyping",
                      hours: "10 hours, 19 lessons",
                      progress: "25%",
                      percentage: 0.25, key: GlobalKey(),
                    ),
                    CardCourses(
                      image: Image.asset("assets/images/icon_2.png", width: 40, height: 40),
                      color: Constants.lightYellow,
                      title: "Sketch shortcuts and tricks",
                      hours: "10 hours, 19 lessons",
                      progress: "50%",
                      percentage: 0.5,key: GlobalKey(),
                    ),
                    CardCourses(
                      image: Image.asset("assets/images/icon_3.png", width: 40, height: 40),
                      color: Constants.lightViolet,
                      title: "UI Motion Design in After Effects",
                      hours: "10 hours, 19 lessons",
                      progress: "75%",
                      percentage: 0.75,key: GlobalKey(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
