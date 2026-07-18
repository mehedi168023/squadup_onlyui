import 'package:flutter/material.dart';

/// Premium border radius system inspired by Samsung One UI
/// Rounded, comfortable, premium feel
class PremiumRadius {
  PremiumRadius._();

  // ============================================================================
  // BASE RADIUS SCALE
  // ============================================================================
  
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double full = 9999.0;
  
  // ============================================================================
  // SEMANTIC RADIUS (Named by component)
  // ============================================================================
  
  /// Buttons
  static const double button = lg;        // 16px
  static const double buttonLarge = xl;   // 20px
  static const double buttonSmall = md;   // 12px
  
  /// Cards
  static const double card = xl;          // 20px
  static const double cardLarge = xxl;    // 24px
  static const double cardSmall = lg;     // 16px
  
  /// Inputs
  static const double input = md;         // 12px
  static const double inputLarge = lg;    // 16px
  
  /// Dialogs & Sheets
  static const double dialog = xxl;       // 24px
  static const double sheet = xxxl;       // 32px (top corners only)
  
  /// Chips & Badges
  static const double chip = full;        // Fully rounded
  static const double badge = full;       // Fully rounded
  
  /// Images & Avatars
  static const double image = lg;         // 16px
  static const double avatar = full;      // Fully rounded
  
  // ============================================================================
  // BORDER RADIUS PRESETS
  // ============================================================================
  
  static const BorderRadius r0 = BorderRadius.zero;
  static const BorderRadius r4 = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius r8 = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius r12 = BorderRadius.all(Radius.circular(md));
  static const BorderRadius r16 = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius r20 = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius r24 = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius r32 = BorderRadius.all(Radius.circular(xxxl));
  static const BorderRadius rFull = BorderRadius.all(Radius.circular(full));
  
  /// Top corners only (for bottom sheets)
  static const BorderRadius rTopSheet = BorderRadius.only(
    topLeft: Radius.circular(sheet),
    topRight: Radius.circular(sheet),
  );
  
  static const BorderRadius rTop16 = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );
  
  static const BorderRadius rTop20 = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );
  
  static const BorderRadius rTop24 = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );
  
  /// Bottom corners only
  static const BorderRadius rBottom16 = BorderRadius.only(
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );
  
  static const BorderRadius rBottom20 = BorderRadius.only(
    bottomLeft: Radius.circular(xl),
    bottomRight: Radius.circular(xl),
  );
  
  static const BorderRadius rBottom24 = BorderRadius.only(
    bottomLeft: Radius.circular(xxl),
    bottomRight: Radius.circular(xxl),
  );
}
