import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeConfig {
  // Premium Fintech Color Palette
  static const _primaryBlue = Color(0xFF0A84FF);        // iOS-inspired fintech blue
  static const _darkPrimary = Color(0xFF0056D3);        // Darker variant
  static const _accentGreen = Color(0xFF00D4AA);        // Success/profit green
  static const _warningAmber = Color(0xFFFFA726);       // Warning/attention amber
  static const _errorRed = Color(0xFFFF3B30);          // Error/loss red
  static const _neutralGray = Color(0xFF8E8E93);       // Neutral text
  static const _backgroundLight = Color(0xFFFAFAFC);   // Premium light bg
  static const _backgroundDark = Color(0xFF000000);    // True black for OLED
  static const _surfaceLight = Color(0xFFFFFFFF);      // Pure white surface
  static const _surfaceDark = Color(0xFF1C1C1E);       // Dark surface
  static const _cardLight = Color(0xFFFFFFFF);         // Light card
  static const _cardDark = Color(0xFF2C2C2E);          // Dark card

  // Light Theme - Premium Fintech Design
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    colorScheme: ColorScheme.light(
      primary: _primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: _primaryBlue.withValues(alpha: 0.1),
      onPrimaryContainer: _darkPrimary,
      secondary: _accentGreen,
      onSecondary: Colors.white,
      secondaryContainer: _accentGreen.withValues(alpha: 0.1),
      onSecondaryContainer: _accentGreen,
      tertiary: _warningAmber,
      onTertiary: Colors.white,
      error: _errorRed,
      onError: Colors.white,
      surface: _surfaceLight,
      onSurface: const Color(0xFF1D1D1F),
      surfaceContainerHighest: const Color(0xFFF2F2F7),
      onSurfaceVariant: _neutralGray,
      outline: const Color(0xFFE5E5EA),
      outlineVariant: const Color(0xFFF2F2F7),
    ),
    
    
    scaffoldBackgroundColor: _backgroundLight,
    fontFamily: 'SF Pro Display',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.6,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.2,
      ),
    ),
    
    // Premium AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: _surfaceLight,
      foregroundColor: const Color(0xFF1D1D1F),
      elevation: 0,
      centerTitle: false,
      titleSpacing: 24,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1D1D1F),
        letterSpacing: -0.1,
      ),
    ),
    
    // Premium Cards with subtle shadows
    cardTheme: CardThemeData(
      color: _cardLight,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: const Color(0xFFE5E5EA).withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    ),
    
    // Premium Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        shadowColor: _primaryBlue.withValues(alpha: 0.3),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    // Outlined buttons for secondary actions
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryBlue,
        side: BorderSide(color: _primaryBlue.withValues(alpha: 0.3), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    // Text buttons for tertiary actions
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    ),
    
    // Premium Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF2F2F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: const Color(0xFFE5E5EA).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _primaryBlue,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _errorRed,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: TextStyle(
        color: _neutralGray.withValues(alpha: 0.8),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // Bottom Navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _surfaceLight,
      selectedItemColor: _primaryBlue,
      unselectedItemColor: _neutralGray,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // FAB Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _primaryBlue,
      foregroundColor: Colors.white,
      elevation: 4,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    
    // Divider Theme
    dividerTheme: DividerThemeData(
      color: const Color(0xFFE5E5EA).withValues(alpha: 0.6),
      thickness: 0.5,
      space: 1,
    ),
  );

  // Dark Theme - Premium Fintech Design
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    colorScheme: ColorScheme.dark(
      primary: _primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: _primaryBlue.withValues(alpha: 0.15),
      onPrimaryContainer: _primaryBlue,
      secondary: _accentGreen,
      onSecondary: Colors.black,
      secondaryContainer: _accentGreen.withValues(alpha: 0.15),
      onSecondaryContainer: _accentGreen,
      tertiary: _warningAmber,
      onTertiary: Colors.black,
      error: _errorRed,
      onError: Colors.white,
      surface: _surfaceDark,
      onSurface: const Color(0xFFF2F2F7),
      surfaceContainerHighest: _cardDark,
      onSurfaceVariant: const Color(0xFF98989D),
      outline: const Color(0xFF48484A),
      outlineVariant: const Color(0xFF3A3A3C),
    ),
    
    fontFamily: 'SF Pro Display',
    
    // Same typography scale
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: Color(0xFFF2F2F7),
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.3,
        color: Color(0xFFF2F2F7),
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
        color: Color(0xFFF2F2F7),
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.4,
        color: Color(0xFFF2F2F7),
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
        color: Color(0xFFF2F2F7),
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.5,
        color: Color(0xFFF2F2F7),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.5,
        color: Color(0xFFF2F2F7),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.6,
        color: Color(0xFF98989D),
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.2,
        color: Color(0xFFF2F2F7),
      ),
    ),
    
    // Dark AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: _backgroundDark,
      foregroundColor: const Color(0xFFF2F2F7),
      elevation: 0,
      centerTitle: false,
      titleSpacing: 24,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF2F2F7),
        letterSpacing: -0.1,
      ),
    ),
    
    // Dark Cards with premium elevation
    cardTheme: CardThemeData(
      color: _cardDark,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: const Color(0xFF48484A).withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    ),
    
    // Dark Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        shadowColor: _primaryBlue.withValues(alpha: 0.4),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryBlue,
        side: BorderSide(color: _primaryBlue.withValues(alpha: 0.5), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    ),
    
    // Dark Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF3A3A3C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: const Color(0xFF48484A).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _primaryBlue,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _errorRed,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: const TextStyle(
        color: Color(0xFF98989D),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // Dark Bottom Navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _surfaceDark,
      selectedItemColor: _primaryBlue,
      unselectedItemColor: const Color(0xFF98989D),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // Dark FAB
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _primaryBlue,
      foregroundColor: Colors.white,
      elevation: 6,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    
    // Dark Divider
    dividerTheme: DividerThemeData(
      color: const Color(0xFF48484A).withValues(alpha: 0.4),
      thickness: 0.5,
      space: 1,
    ),
  );

  // Theme animation duration for smooth transitions
  static const Duration themeAnimationDuration = Duration(milliseconds: 300);
}