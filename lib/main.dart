import 'package:elearning/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:elearning/Onboarding/Splash.dart';
// import 'package:dynamic_color/dynamic_color.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Learning Online Courses App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: systemUiOverlayStyle(
          system: ThemeMode.system,
          light: Colors.white,
          dark: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
          bodyMedium: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.black ,
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
      home: const Splash(),
      routes: {
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
  
  systemUiOverlayStyle({required Color light, required Color dark, required ThemeMode system}) {}
}
