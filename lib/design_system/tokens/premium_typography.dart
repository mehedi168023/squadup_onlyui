import 'package:flutter/material.dart';

/// Premium typography system inspired by Samsung One UI
/// Large, comfortable, readable text hierarchy
class PremiumTypography {
  PremiumTypography._();

  // ============================================================================
  // FONT FAMILIES
  // ============================================================================
  
  /// Primary font - Google Sans (body, UI elements)
  static const String primaryFont = 'GoogleSans';
  
  /// Display font - Baloo Da 2 (headings, branding)
  static const String displayFont = 'BalooDa2';
  
  // ============================================================================
  // FONT WEIGHTS
  // ============================================================================
  
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  
  // ============================================================================
  // DISPLAY STYLES (Large Hero Text)
  // ============================================================================
  
  /// Extra large display (e.g., splash screen, hero sections)
  static const TextStyle display1 = TextStyle(
    fontFamily: displayFont,
    fontSize: 56,
    height: 1.1,
    fontWeight: extraBold,
    letterSpacing: -0.5,
  );
  
  static const TextStyle display2 = TextStyle(
    fontFamily: displayFont,
    fontSize: 48,
    height: 1.15,
    fontWeight: extraBold,
    letterSpacing: -0.5,
  );
  
  static const TextStyle display3 = TextStyle(
    fontFamily: displayFont,
    fontSize: 40,
    height: 1.2,
    fontWeight: extraBold,
    letterSpacing: -0.3,
  );
  
  // ============================================================================
  // HEADING STYLES (Section Headers)
  // ============================================================================
  
  /// H1 - Main page titles
  static const TextStyle h1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    height: 1.25,
    fontWeight: bold,
    letterSpacing: -0.3,
  );
  
  /// H2 - Section titles
  static const TextStyle h2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    height: 1.3,
    fontWeight: bold,
    letterSpacing: -0.2,
  );
  
  /// H3 - Subsection titles
  static const TextStyle h3 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    height: 1.35,
    fontWeight: bold,
    letterSpacing: -0.1,
  );
  
  /// H4 - Card titles, component headers
  static const TextStyle h4 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    height: 1.4,
    fontWeight: semiBold,
    letterSpacing: 0,
  );
  
  /// H5 - Small headers
  static const TextStyle h5 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    height: 1.45,
    fontWeight: semiBold,
    letterSpacing: 0,
  );
  
  /// H6 - Tiny headers
  static const TextStyle h6 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    height: 1.5,
    fontWeight: semiBold,
    letterSpacing: 0,
  );
  
  // ============================================================================
  // BODY STYLES (Content Text)
  // ============================================================================
  
  /// Large body text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 17,
    height: 1.5,
    fontWeight: regular,
    letterSpacing: 0,
  );
  
  /// Default body text
  static const TextStyle body = TextStyle(
    fontFamily: primaryFont,
    fontSize: 15,
    height: 1.5,
    fontWeight: regular,
    letterSpacing: 0,
  );
  
  /// Medium body text (emphasized)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 15,
    height: 1.5,
    fontWeight: medium,
    letterSpacing: 0,
  );
  
  /// Small body text
  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    height: 1.5,
    fontWeight: regular,
    letterSpacing: 0,
  );
  
  // ============================================================================
  // LABEL STYLES (UI Elements)
  // ============================================================================
  
  /// Large label (buttons, tabs)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    height: 1.4,
    fontWeight: semiBold,
    letterSpacing: 0.1,
  );
  
  /// Default label
  static const TextStyle label = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    height: 1.4,
    fontWeight: medium,
    letterSpacing: 0.1,
  );
  
  /// Small label
  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    height: 1.35,
    fontWeight: medium,
    letterSpacing: 0.2,
  );
  
  // ============================================================================
  // CAPTION STYLES (Small Supporting Text)
  // ============================================================================
  
  static const TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontSize: 13,
    height: 1.4,
    fontWeight: regular,
    letterSpacing: 0,
  );
  
  static const TextStyle captionMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 13,
    height: 1.4,
    fontWeight: medium,
    letterSpacing: 0,
  );
  
  static const TextStyle captionSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 11,
    height: 1.35,
    fontWeight: regular,
    letterSpacing: 0.1,
  );
  
  // ============================================================================
  // SPECIAL STYLES (Numbers, Currency, Gaming)
  // ============================================================================
  
  /// Large currency/numbers (wallet balance)
  static const TextStyle currencyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 36,
    height: 1.2,
    fontWeight: bold,
    letterSpacing: -0.5,
  );
  
  /// Medium currency/numbers (prize pools)
  static const TextStyle currencyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    height: 1.3,
    fontWeight: bold,
    letterSpacing: -0.3,
  );
  
  /// Small currency/numbers (entry fees)
  static const TextStyle currencySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    height: 1.4,
    fontWeight: semiBold,
    letterSpacing: 0,
  );
  
  /// Countdown timer
  static const TextStyle countdown = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    height: 1.2,
    fontWeight: bold,
    letterSpacing: 1,
  );
  
  /// Stats numbers (kills, rank, etc.)
  static const TextStyle stats = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    height: 1.3,
    fontWeight: bold,
    letterSpacing: -0.2,
  );
  
  // ============================================================================
  // BUTTON STYLES
  // ============================================================================
  
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 17,
    height: 1.3,
    fontWeight: semiBold,
    letterSpacing: 0.3,
  );
  
  static const TextStyle button = TextStyle(
    fontFamily: primaryFont,
    fontSize: 15,
    height: 1.3,
    fontWeight: semiBold,
    letterSpacing: 0.3,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 13,
    height: 1.3,
    fontWeight: medium,
    letterSpacing: 0.3,
  );
}

/// Typography extension for easy access
extension PremiumTypographyX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  // Quick access to premium typography
  TextStyle get display1 => PremiumTypography.display1;
  TextStyle get display2 => PremiumTypography.display2;
  TextStyle get display3 => PremiumTypography.display3;
  
  TextStyle get h1 => PremiumTypography.h1;
  TextStyle get h2 => PremiumTypography.h2;
  TextStyle get h3 => PremiumTypography.h3;
  TextStyle get h4 => PremiumTypography.h4;
  TextStyle get h5 => PremiumTypography.h5;
  TextStyle get h6 => PremiumTypography.h6;
  
  TextStyle get bodyLarge => PremiumTypography.bodyLarge;
  TextStyle get body => PremiumTypography.body;
  TextStyle get bodyMedium => PremiumTypography.bodyMedium;
  TextStyle get bodySmall => PremiumTypography.bodySmall;
  
  TextStyle get labelLarge => PremiumTypography.labelLarge;
  TextStyle get label => PremiumTypography.label;
  TextStyle get labelSmall => PremiumTypography.labelSmall;
  
  TextStyle get caption => PremiumTypography.caption;
  TextStyle get captionSmall => PremiumTypography.captionSmall;
}
