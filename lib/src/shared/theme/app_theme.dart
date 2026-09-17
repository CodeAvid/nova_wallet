import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  // Light
  static const primary = Color(0xFF2B3B7C);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFC9962C);
  static const onSecondary = Color(0xFFFFFFFF);
  static const tertiary = Color(0xFFB85C4A);
  static const error = Color(0xFFC13B3B);
  static const success = Color(0xFF19745A);
  static const successContainer = Color(0xFFE4F4EC);
  static const background = Color(0xFFF7F5F0);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFEFECE5);
  static const onSurface = Color(0xFF12162B);
  static const onSurfaceMuted = Color(0xFF12162B);
  static const outline = Color(0xFFE5E0D8);
  static const primaryContainer = Color(0xFFF4F2FF);

  // Dark — same brand primaries, inverted neutrals
  static const darkBackground = Color(0xFF0E1117);
  static const darkSurface = Color(0xFF1A1F2E);
  static const darkSurfaceVariant = Color(0xFF252B3B);
  static const darkOnSurface = Color(0xFFF0EEE9);
  static const darkOutline = Color(0xFF2E3347);
  static const darkPrimaryContainer = Color(0xFF1E2440);
  static const darkSuccessContainer = Color(0xFF0D2B22);
}

// Currency / financial figures — call as context.currencyDisplay, etc.
extension AppTextStyles on BuildContext {
  TextStyle get currencyDisplay => GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.03 * 36,
    fontFeatures: const [FontFeature.tabularFigures()],
    color: AppColors.onSurface,
  );

  TextStyle get currencyLg => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.02 * 24,
    fontFeatures: const [FontFeature.tabularFigures()],
    color: AppColors.onSurface,
  );

  TextStyle get currencyMd => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01 * 16,
    fontFeatures: const [FontFeature.tabularFigures()],
    color: AppColors.onSurface,
  );
}

abstract final class AppTheme {
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      surfaceContainerLowest: AppColors.darkBackground,
      error: AppColors.error,
      outline: AppColors.darkOutline,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
    );

    return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurface,
          letterSpacing: 0,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: GoogleFonts.beVietnamPro(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.darkOutline),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: GoogleFonts.beVietnamPro(
          fontSize: 14,
          color: AppColors.darkOnSurface.withValues(alpha: 0.6),
        ),
        hintStyle: GoogleFonts.beVietnamPro(
          fontSize: 14,
          color: AppColors.darkOnSurface.withValues(alpha: 0.4),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkOutline,
        thickness: 1,
        space: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        selectedColor: AppColors.primary,
        labelStyle: GoogleFonts.beVietnamPro(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.darkOnSurface,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        side: BorderSide.none,
      ),
    );
  }

  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          tertiary: AppColors.tertiary,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          surfaceContainerLowest: AppColors.background,
          error: AppColors.error,
          outline: AppColors.outline,
          surfaceContainerHighest: AppColors.surfaceVariant,
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
          letterSpacing: 0,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: GoogleFonts.beVietnamPro(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.outline),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.outline),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: GoogleFonts.beVietnamPro(
          fontSize: 14,
          color: AppColors.onSurface.withValues(alpha: 0.6),
        ),
        hintStyle: GoogleFonts.beVietnamPro(
          fontSize: 14,
          color: AppColors.onSurface.withValues(alpha: 0.4),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primary,
        labelStyle: GoogleFonts.beVietnamPro(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        side: BorderSide.none,
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.merge(GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.03 * 57,
      )),
      displayMedium: base.displayMedium?.merge(GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02 * 45,
      )),
      displaySmall: base.displaySmall?.merge(GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02 * 36,
      )),
      headlineLarge: base.headlineLarge?.merge(GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.02 * 32,
      )),
      headlineMedium: base.headlineMedium?.merge(GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01 * 22,
      )),
      headlineSmall: base.headlineSmall?.merge(GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      )),
      titleLarge: base.titleLarge?.merge(GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      )),
      titleMedium: base.titleMedium?.merge(GoogleFonts.beVietnamPro(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      )),
      titleSmall: base.titleSmall?.merge(GoogleFonts.beVietnamPro(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      )),
      bodyLarge: base.bodyLarge?.merge(GoogleFonts.beVietnamPro(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      )),
      bodyMedium: base.bodyMedium?.merge(GoogleFonts.beVietnamPro(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      )),
      bodySmall: base.bodySmall?.merge(GoogleFonts.beVietnamPro(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      )),
      labelLarge: base.labelLarge?.merge(GoogleFonts.beVietnamPro(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      )),
      labelMedium: base.labelMedium?.merge(GoogleFonts.beVietnamPro(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      )),
      labelSmall: base.labelSmall?.merge(GoogleFonts.beVietnamPro(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.01 * 11,
      )),
    );
  }
}
