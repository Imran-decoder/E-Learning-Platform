import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning/screens/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:elearning/screens/';

class ScoreScreen extends StatefulWidget {
  final String courseId; // Pass the courseId dynamically
  final String taskId; // Pass the taskId dynamically
  final String score; // The score is passed as a string (percentage)

  const ScoreScreen({
    required this.courseId,
    required this.taskId,
    required this.score,
    Key? key,
  }) : super(key: key);

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> with TickerProviderStateMixin {
  bool _isLoading = true; // For showing a loading indicator
  String? _errorMessage; // For error handling
  String? _userName; // To store the user's name

  late AnimationController _controller; // Controller for the animation
  late Animation<double> _scaleAnimation; // Animation for scaling the score
  late Animation<Offset> _slideAnimation; // Animation for sliding the score

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch user's name on init

    // Initialize animations
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward(); // Start animations
    _updateScoreInFirestore(); // Update score when widget is initialized
  }

  // Fetch the user's name
  Future<void> _fetchUserName() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser; // Get the current user
      if (user != null) {
        // Access the user's document in the Users collection
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        final userName = userDoc['userName'];
        setState(() {
          _userName = userName;
          _isLoading = false; // Set loading to false once the name is fetched
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching user name.';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateScoreInFirestore() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reference to the user's document in Firestore
        final DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);

        // Reference to the scores sub-collection for this user
        final CollectionReference scoresCollection = userDocRef.collection('scores');

        // Check if the sub-collection already exists by fetching a document
        final QuerySnapshot scoresSnapshot = await scoresCollection.get();

        // If the sub-collection does not exist (no documents), create it and add the task score
        if (scoresSnapshot.docs.isEmpty) {
          // Create a new document in the scores sub-collection and use taskId as the field name
          await scoresCollection.doc('taskScores').set({
            widget.taskId: double.parse(widget.score), // Store taskId as a field name and score as its value
          });
        } else {
          // If the sub-collection exists, update or add the score for the taskId
          final DocumentSnapshot taskScoreDoc = await scoresCollection.doc('taskScores').get();

          if (taskScoreDoc.exists) {
            // If the document exists for the taskId, update the score
            await scoresCollection.doc('taskScores').update({
              widget.taskId: double.parse(widget.score),
            });
          } else {
            // If the document doesn't exist, create a new document with taskId as field name
            await scoresCollection.doc('taskScores').set({
              widget.taskId: double.parse(widget.score),
            });
          }
        }
      }
    } catch (e) {
     // debugPrint("Error updating score: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Completed'),
          backgroundColor: Colors.deepOrange,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Completed'),
          backgroundColor: Colors.deepOrange,
        ),
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Get the screen size using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;

    // Set max font size based on screen size
    final scoreFontSize = screenWidth > 400 ? 48.0 : screenWidth * 0.1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Completed'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        color: Colors.orange[50],
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_userName != null)
                SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    'Congratulations, $_userName!',
                    style: TextStyle(
                      fontSize: screenWidth > 400 ? 30 : screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  'Your Score: ${widget.score}%',
                  style: TextStyle(
                    fontSize: scoreFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepOrange,
                  ),
                  textAlign: TextAlign.center, // Ensure the text is centered
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  // Navigate to CourseDetailScreen
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DashboardScreen(),
                  //   ),
                  // );
                 Navigator.pop(context);
                 Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.deepOrange,
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Home',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
