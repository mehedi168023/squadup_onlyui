import 'package:flutter/material.dart';

/// Premium Samsung One UI-inspired color system
/// Original design - not cloning Samsung's proprietary colors
/// Deep AMOLED-optimized dark theme + adaptive light theme
class PremiumColors {
  PremiumColors._();

  // ============================================================================
  // DARK THEME - AMOLED Optimized
  // ============================================================================
  
  /// Pure black for AMOLED displays - maximum battery efficiency
  static const Color darkBg = Color(0xFF000000);
  
  /// Elevated surface - subtle depth
  static const Color darkSurface1 = Color(0xFF0A0A0E);
  static const Color darkSurface2 = Color(0xFF121218);
  static const Color darkSurface3 = Color(0xFF1A1A24);
  static const Color darkSurface4 = Color(0xFF22222E);
  
  /// Card and component surfaces
  static const Color darkCard = Color(0xFF151520);
  static const Color darkCardElevated = Color(0xFF1C1C28);
  
  /// Borders and dividers
  static const Color darkBorder = Color(0xFF252532);
  static const Color darkBorderSubtle = Color(0xFF1A1A24);
  static const Color darkDivider = Color(0xFF2A2A38);
  
  // ============================================================================
  // LIGHT THEME - Clean & Professional
  // ============================================================================
  
  /// Soft white background
  static const Color lightBg = Color(0xFFF5F7FA);
  static const Color lightBgAlt = Color(0xFFFFFFFF);
  
  /// Elevated surfaces
  static const Color lightSurface1 = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFFBFCFD);
  static const Color lightSurface3 = Color(0xFFF8F9FB);
  
  /// Cards
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardElevated = Color(0xFFFDFDFE);
  
  /// Borders
  static const Color lightBorder = Color(0xFFE4E7EB);
  static const Color lightBorderSubtle = Color(0xFFF0F2F5);
  static const Color lightDivider = Color(0xFFEAECF0);
  
  // ============================================================================
  // BRAND COLORS - Primary (Purple/Violet)
  // ============================================================================
  
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryDark = Color(0xFF6D28D9);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primarySoft = Color(0xFF9F7AEA);
  static const Color primaryPale = Color(0xFFDDD6FE);
  
  /// Primary shades (50-900)
  static const Color primary50 = Color(0xFFF5F3FF);
  static const Color primary100 = Color(0xFFEDE9FE);
  static const Color primary200 = Color(0xFFDDD6FE);
  static const Color primary300 = Color(0xFFC4B5FD);
  static const Color primary400 = Color(0xFFA78BFA);
  static const Color primary500 = Color(0xFF8B5CF6);
  static const Color primary600 = Color(0xFF7C3AED);
  static const Color primary700 = Color(0xFF6D28D9);
  static const Color primary800 = Color(0xFF5B21B6);
  static const Color primary900 = Color(0xFF4C1D95);
  
  // ============================================================================
  // SEMANTIC COLORS
  // ============================================================================
  
  /// Success (Green)
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color successLight = Color(0xFF34D399);
  static const Color successPale = Color(0xFFD1FAE5);
  
  /// Winning (Teal/Emerald)
  static const Color winning = Color(0xFF14B8A6);
  static const Color winningDark = Color(0xFF0D9488);
  static const Color winningLight = Color(0xFF2DD4BF);
  static const Color winningPale = Color(0xFFCCFBF1);
  
  /// Danger (Red)
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerDark = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFF87171);
  static const Color dangerPale = Color(0xFFFEE2E2);
  
  /// Warning (Orange/Amber)
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningPale = Color(0xFFFEF3C7);
  
  /// Info (Blue)
  static const Color info = Color(0xFF3B82F6);
  static const Color infoDark = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoPale = Color(0xFFDBEAFE);
  
  // ============================================================================
  // GAMING ACCENT COLORS
  // ============================================================================
  
  /// Gold (Premium rewards)
  static const Color gold = Color(0xFFFFB800);
  static const Color goldDark = Color(0xFFF59E0B);
  static const Color goldLight = Color(0xFFFCD34D);
  static const Color goldShine = Color(0xFFFDE68A);
  
  /// Silver
  static const Color silver = Color(0xFFA8B4C0);
  static const Color silverDark = Color(0xFF8B99A8);
  static const Color silverLight = Color(0xFFC5CFD9);
  
  /// Bronze
  static const Color bronze = Color(0xFFCD7F32);
  static const Color bronzeDark = Color(0xFFB86F2C);
  static const Color bronzeLight = Color(0xFFE09858);
  
  /// Gaming specific
  static const Color killRed = Color(0xFFFF3B5C);
  static const Color winGreen = Color(0xFF00E676);
  static const Color liveRed = Color(0xFFFF0000);
  static const Color matchGreen = Color(0xFF00C853);
  
  // ============================================================================
  // TEXT COLORS
  // ============================================================================
  
  /// Dark theme text
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextMedium = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B8);
  static const Color darkTextTertiary = Color(0xFF80808C);
  static const Color darkTextDisabled = Color(0xFF505058);
  
  /// Light theme text
  static const Color lightText = Color(0xFF0F0F14);
  static const Color lightTextMedium = Color(0xFF2A2A32);
  static const Color lightTextSecondary = Color(0xFF5A5A64);
  static const Color lightTextTertiary = Color(0xFF8A8A94);
  static const Color lightTextDisabled = Color(0xFFBCBCC4);
  
  // ============================================================================
  // GRADIENT COLLECTIONS
  // ============================================================================
  
  /// Primary gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  /// Success gradient
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF34D399), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Winning gradient
  static const LinearGradient winningGradient = LinearGradient(
    colors: [Color(0xFF2DD4BF), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Danger gradient
  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFF87171), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Gold gradient
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFCD34D), Color(0xFFFFB800), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Premium dark shimmer gradient
  static const LinearGradient darkShimmerGradient = LinearGradient(
    colors: [
      Color(0xFF1A1A24),
      Color(0xFF22222E),
      Color(0xFF1A1A24),
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    stops: [0.0, 0.5, 1.0],
  );
  
  /// Premium glass effect colors
  static const Color glassWhite = Color(0x14FFFFFF);
  static const Color glassDark = Color(0x14000000);
  static const Color glassBorder = Color(0x28FFFFFF);
  
  // ============================================================================
  // OVERLAY COLORS
  // ============================================================================
  
  static const Color overlayLight = Color(0x14FFFFFF);
  static const Color overlayMedium = Color(0x28FFFFFF);
  static const Color overlayStrong = Color(0x3CFFFFFF);
  static const Color overlayDarkLight = Color(0x14000000);
  static const Color overlayDarkMedium = Color(0x28000000);
  static const Color overlayDarkStrong = Color(0x3C000000);
  
  /// Scrim (backdrop)
  static const Color scrimLight = Color(0x66000000);
  static const Color scrimMedium = Color(0x99000000);
  static const Color scrimHeavy = Color(0xCC000000);
  
  static const String currencySymbol = '৳';
}

/// Context-aware color extension
extension PremiumColorsX on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;
  
  Color get bg => _isDark ? PremiumColors.darkBg : PremiumColors.lightBg;
  Color get bgAlt => _isDark ? PremiumColors.darkSurface1 : PremiumColors.lightBgAlt;
  Color get surface => _isDark ? PremiumColors.darkSurface2 : PremiumColors.lightSurface1;
  Color get surface2 => _isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface2;
  Color get surface3 => _isDark ? PremiumColors.darkSurface4 : PremiumColors.lightSurface3;
  Color get card => _isDark ? PremiumColors.darkCard : PremiumColors.lightCard;
  Color get cardElevated => _isDark ? PremiumColors.darkCardElevated : PremiumColors.lightCardElevated;
  Color get border => _isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder;
  Color get borderSubtle => _isDark ? PremiumColors.darkBorderSubtle : PremiumColors.lightBorderSubtle;
  Color get divider => _isDark ? PremiumColors.darkDivider : PremiumColors.lightDivider;
  
  Color get text => _isDark ? PremiumColors.darkText : PremiumColors.lightText;
  Color get textMedium => _isDark ? PremiumColors.darkTextMedium : PremiumColors.lightTextMedium;
  Color get textSecondary => _isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary;
  Color get textTertiary => _isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary;
  Color get textDisabled => _isDark ? PremiumColors.darkTextDisabled : PremiumColors.lightTextDisabled;
}
