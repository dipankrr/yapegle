import 'package:flutter/material.dart';
import 'app_colors.dart'; // Import your app's color configuration

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'SpaceGrotesk',

      // Set global background color for Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // Primary color and accent color
      primaryColor: AppColors.primary,
      // accentColor: AppColors.primary,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.appBarBackground,
        iconTheme: IconThemeData(color: AppColors.iconPrimary), // White icons in AppBar
      ),

      // Text Theme
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.textPrimary,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        hintStyle: TextStyle(color: AppColors.textSecondary),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),

      // Custom Divider Color
      dividerColor: AppColors.divider,

      // Other theme customization can go here
    );
  }
}
