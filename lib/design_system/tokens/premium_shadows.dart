import 'package:flutter/material.dart';
import 'premium_colors.dart';

/// Premium shadow and elevation system inspired by Samsung One UI
/// Natural, subtle depth with layered shadows
class PremiumShadows {
  PremiumShadows._();

  // ============================================================================
  // ELEVATION LEVELS (Material Design inspired, premium tuned)
  // ============================================================================
  
  static const double level0 = 0.0;
  static const double level1 = 2.0;
  static const double level2 = 4.0;
  static const double level3 = 8.0;
  static const double level4 = 12.0;
  static const double level5 = 16.0;
  static const double level6 = 24.0;
  
  // ============================================================================
  // DARK THEME SHADOWS (Subtle, for AMOLED)
  // ============================================================================
  
  /// Subtle shadow for cards on dark background
  static const List<BoxShadow> darkCard = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
  
  /// Elevated card shadow (stronger)
  static const List<BoxShadow> darkCardElevated = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
  
  /// Button shadow (pressed state)
  static const List<BoxShadow> darkButton = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
  
  /// Dialog/modal shadow
  static const List<BoxShadow> darkDialog = [
    BoxShadow(
      color: Color(0x29000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 16),
      blurRadius: 48,
      spreadRadius: 0,
    ),
  ];
  
  // ============================================================================
  // LIGHT THEME SHADOWS (More prominent)
  // ============================================================================
  
  /// Light theme card shadow
  static const List<BoxShadow> lightCard = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x05000000),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
  
  /// Elevated card shadow
  static const List<BoxShadow> lightCardElevated = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
  
  /// Button shadow
  static const List<BoxShadow> lightButton = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
  
  /// Dialog shadow
  static const List<BoxShadow> lightDialog = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 16),
      blurRadius: 48,
      spreadRadius: 0,
    ),
  ];
  
  // ============================================================================
  // COLORED SHADOWS (for brand elements)
  // ============================================================================
  
  /// Primary purple glow
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x337C3AED),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
  
  /// Success green glow
  static const List<BoxShadow> successGlow = [
    BoxShadow(
      color: Color(0x3310B981),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
  
  /// Danger red glow
  static const List<BoxShadow> dangerGlow = [
    BoxShadow(
      color: Color(0x33EF4444),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
  
  /// Gold glow (for premium features)
  static const List<BoxShadow> goldGlow = [
    BoxShadow(
      color: Color(0x33FFB800),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
  
  // ============================================================================
  // INNER SHADOWS (using borders as approximation)
  // ============================================================================
  
  /// Inner shadow effect (for pressed buttons, input fields)
  static const List<BoxShadow> innerShadow = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
  ];
}

/// Context-aware shadow extension
extension PremiumShadowsX on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;
  
  List<BoxShadow> get shadowCard => _isDark ? PremiumShadows.darkCard : PremiumShadows.lightCard;
  List<BoxShadow> get shadowCardElevated => _isDark ? PremiumShadows.darkCardElevated : PremiumShadows.lightCardElevated;
  List<BoxShadow> get shadowButton => _isDark ? PremiumShadows.darkButton : PremiumShadows.lightButton;
  List<BoxShadow> get shadowDialog => _isDark ? PremiumShadows.darkDialog : PremiumShadows.lightDialog;
}
