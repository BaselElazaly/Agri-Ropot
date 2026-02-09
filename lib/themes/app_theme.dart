import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    fontFamily: 'CustomFont',
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontFamily: 'CustomFont',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    fontFamily: 'CustomFont',
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontFamily: 'CustomFont',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
  );
}
