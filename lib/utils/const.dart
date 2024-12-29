import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  // Name
  static String appName = "e-Learning";

  // Material Design Color
  static Color lightPrimary = const Color(0xfffcfcff);
  static Color lightAccent = const Color(0xFFF18C8E);
  static Color lightBackground = const Color(0xfffcfcff);

  static Color grey = const Color(0xff707070);
  static Color textPrimary = const Color(0xFF486581);
  static Color textDark = const Color(0xFF305F72);

  // Salmon
  static Color salmonMain = const Color(0xFFF18C8E);
  static Color salmonDark = const Color(0xFFBB7F87);
  static Color salmonLight = const Color(0xFFF19895);

  // Blue

  static Color blueMain = const Color(0xFF579ACA);
  static Color blueDark = const Color(0xFF4E92B1);
  static Color blueLight = const Color(0xFF5AA6C8);

  // Pink
  static Color lightPink = const Color(0xFFFAE4F4);

  // Yellow
  static Color lightYellow = const Color(0xFFFFF5E5);

  // Violet
  static Color lightViolet = const Color(0xFFFBF5FF);

  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      primaryColor: lightPrimary,
      hintColor: lightAccent,
      cardColor: lightAccent,
      scaffoldBackgroundColor: lightBackground,
      textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      appBarTheme: AppBarTheme(
        //textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        iconTheme: IconThemeData(
          color: lightAccent,
        ), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ), brightness: Brightness.light,
    );
  }

  static double headerHeight = 228.5;
  static double mainPadding = 20.0;
}
