import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';

// Theme configuration for the app
ThemeData getAppTheme() {
  return ThemeData(
    useMaterial3: false,
    primaryColor: mainColor,
    primarySwatch: MaterialColor(mainColor.value, {
      50: const Color(0xFFE3F5FD),
      100: const Color(0xFFB8E6FA),
      200: const Color(0xFF8AD6F7),
      300: const Color(0xFF5CC5F4),
      400: const Color(0xFF38B9F4), // Same as mainColor
      500: const Color(0xFF14ADF2),
      600: const Color(0xFF12A6E0),
      700: const Color(0xFF0E9CCB),
      800: const Color(0xFF0B93B7),
      900: const Color(0xFF068296),
    }),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(color: Colors.white, elevation: 0),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: mainColor,
      selectionColor: mainColor.withOpacity(0.2),
      selectionHandleColor: mainColor,
    ),
  );
}
