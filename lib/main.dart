import 'package:flutter/material.dart';
import 'package:elearning/screens/dashboard_screen.dart'; // Import DashboardScreen
import 'package:elearning/screens/profile/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:elearning/Onboarding/sign-up.dart';
import 'package:elearning/Onboarding/check_stateof_login.dart';
import 'package:elearning/Onboarding/splash.dart';
import 'package:elearning/Onboarding/login.dart';
import 'package:elearning/Onboarding/forgot_pass.dart';
import 'package:elearning/Onboarding/varification.dart';
import 'package:elearning/Onboarding/change_pass.dart';
import 'package:elearning/Onboarding/secpage_of_signup.dart';
import 'package:elearning/screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Learning Online Courses App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
      home: Splash(),
      routes: {
        '/dashboard': (context) => BottomNavBarApp(),
        '/profile': (context) => ProfileScreen(),
        '/signup': (context) => SignUpScreen(),
        '/log-sign': (context) => SigninOrSignupScreen(),
        '/login': (context) => SignInScreen(),
        '/forgot': (context) => ForgotPasswordScreen(),
        '/verify': (context) => VerificationScreen(phoneNumber: '', onVerificationSuccess: (String ) {  },),
        '/change': (context) => ChangePasswordScreen(),
        '/secpage': (context) => ComplateProfileScreen(),
        
      },
    );
  }
}

class BottomNavBarApp extends StatefulWidget {
  const BottomNavBarApp({super.key});

  @override
  _BottomNavBarAppState createState() => _BottomNavBarAppState();
}

class _BottomNavBarAppState extends State<BottomNavBarApp> {
  int _selectedIndex = 0;

  // List of screens for navigation, including all 4 items for the tabs
  final List<Widget> _screens = [
    DashboardScreen(),  // Home Screen
    ChatScreen(),       // Chat Screen
    ProfileScreen(),    // Profile Screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],  // Display the screen based on selected index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index); 
          
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.white,
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.black,
        elevation: 5,
        selectedIconTheme: IconThemeData(
          color: Colors.orangeAccent,
          size: 25,
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.black,
          size: 25,
        ),
        selectedLabelStyle: TextStyle(
          color: Colors.white,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.black,
        ),
        showUnselectedLabels: true,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  // Function to handle sending a message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
      });
      _controller.clear(); // Clear the input field after sending the message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Makes the newest message appear at the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[_messages.length - 1 - index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

