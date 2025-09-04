import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  // Palette: indigo primary, amber accents, soft surfaces
  const seed = Colors.indigo;
  final scheme = ColorScheme.fromSeed(seedColor: seed).copyWith(
    primary: Colors.indigo, // brand color
    secondary: Colors.amber, // accent
    surface: const Color(0xFFF7F7FB),
    onSurface: const Color(0xFF1E1E24),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    // Keep the default platform fonts; tweak sizes/weights only.
    // If you want a custom font later, add assets (no extra package required).
    textTheme: const TextTheme(
      // Big page titles (AppBar picks this automatically via appBarTheme.titleTextStyle)
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      // Card/List titles
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      // Secondary text
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.3,
      ),
      // Labels (buttons, inputs)
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: Colors.white,
      elevation: 1,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: scheme.primary,
      textColor: scheme.onSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: scheme.primary),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: scheme.surface,
    dividerColor: scheme.primary.withOpacity(0.08),
  );
}
