import 'package:flutter/material.dart';

class AppTheme {
  // Custom colors
  static const Color dustyRose = Color(0xFFCC8B86);
  static const Color linen = Color(0xFFFAF0E6);
  static const Color darkBg = Color(0xFF3C2C2A);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: dustyRose,
      primarySwatch: MaterialColor(
        dustyRose.value,
        <int, Color>{
          50: Color(0xFFFAF0ED),
          100: Color(0xFFF4DEDAD),
          200: Color(0xFFEDCCC3),
          300: Color(0xFFE5BAB9),
          400: Color(0xFFDDA8AF),
          500: dustyRose,
          600: Color(0xFFC47D7E),
          700: Color(0xFFBB7575),
          800: Color(0xFFB26D6D),
          900: Color(0xFFA35F5F),
        },
      ),
      scaffoldBackgroundColor: linen,
      appBarTheme: AppBarTheme(
        backgroundColor: dustyRose,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: dustyRose),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: dustyRose, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: dustyRose,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: dustyRose,
      primarySwatch: MaterialColor(
        dustyRose.value,
        <int, Color>{
          50: Color(0xFFFAF0ED),
          100: Color(0xFFF4DEDAD),
          200: Color(0xFFEDCCC3),
          300: Color(0xFFE5BAB9),
          400: Color(0xFFDDA8AF),
          500: dustyRose,
          600: Color(0xFFC47D7E),
          700: Color(0xFFBB7575),
          800: Color(0xFFB26D6D),
          900: Color(0xFFA35F5F),
        },
      ),
      scaffoldBackgroundColor: darkBg,
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF4A3A37),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: dustyRose),
        ),
        filled: true,
        fillColor: Color(0xFF4A3A37),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: dustyRose, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: dustyRose,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
