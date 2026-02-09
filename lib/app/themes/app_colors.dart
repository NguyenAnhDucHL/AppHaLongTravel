import 'package:flutter/material.dart';

/// App color palette inspired by Ha Long Bay
class AppColors {
  // Primary colors - Ocean Blues
  static const Color primaryBlue = Color(0xFF0077BE); // Deep ocean blue
  static const Color primaryLight = Color(0xFF4FC3F7); // Light sky blue
  static const Color primaryDark = Color(0xFF004D7A); // Dark navy
  
  // Accent colors - Sunset & Tropical
  static const Color accentOrange = Color(0xFFFF6B35); // Sunset orange
  static const Color accentCoral = Color(0xFFFF8A65); // Coral
  static const Color accentGold = Color(0xFFFFB300); // Golden hour
  
  // Neutral colors
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);
  
  // Text colors
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF616161);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);
  
  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF0077BE),
    Color(0xFF00BCD4),
  ];
  
  static const List<Color> sunsetGradient = [
    Color(0xFFFF6B35),
    Color(0xFFFFB300),
  ];
  
  static const List<Color> overlayGradient = [
    Color(0x00000000),
    Color(0xAA000000),
  ];
}
