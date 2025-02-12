import 'package:elearning/Onboarding/admin_login.dart';
import 'package:elearning/firebase_api.dart';
import 'package:elearning/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elearning/screens/dashboard_screen.dart';
import 'package:elearning/screens/profile/profile_screen.dart';
import 'package:elearning/screens/notification_screen.dart'; // Import NotificationScreen
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
import 'package:elearning/screens/Admin/admin_dashboard_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Ensure Firebase API is initialized properly
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  if (userId.isNotEmpty) {
    await FirebaseApi().initNotifications(userId);
  }

  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
      navigatorKey: navigatorKey,
      home: Splash(),
      routes: {
        '/dashboard': (context) => BottomNavBarApp(),
        '/profile': (context) => ProfileScreen(),
        '/signup': (context) => SignUpScreen(),
        '/log-sign': (context) => SigninOrSignupScreen(),
        '/login': (context) => SignInScreen(),
        '/forgot': (context) => ForgotPasswordScreen(),
        '/verify': (context) => VerificationScreen(phoneNumber: '', onVerificationSuccess: (String string) {}),
        '/change': (context) => ChangePasswordScreen(),
        '/secpage': (context) => ComplateProfileScreen(),
        '/admin': (context) => AdminLogin(),
        '/admin_dashboard': (context) => AdminDashboardScreen(),
        '/notifications': (context) => NotificationScreen(), // Add Notification Screen Route
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

  final List<Widget> _screens = [
    DashboardScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
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
        showUnselectedLabels: true,
      ),
    );
  }
}
