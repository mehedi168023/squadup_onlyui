import 'package:flutter/material.dart';

/// Premium spacing system inspired by Samsung One UI
/// Large, comfortable spacing for premium feel
class PremiumSpacing {
  PremiumSpacing._();

  // ============================================================================
  // BASE SPACING SCALE (4px base unit)
  // ============================================================================
  
  static const double xxxs = 2.0;   // 2px
  static const double xxs = 4.0;    // 4px
  static const double xs = 8.0;     // 8px
  static const double sm = 12.0;    // 12px
  static const double md = 16.0;    // 16px
  static const double lg = 20.0;    // 20px
  static const double xl = 24.0;    // 24px
  static const double xxl = 32.0;   // 32px
  static const double xxxl = 40.0;  // 40px
  static const double huge = 48.0;  // 48px
  static const double giant = 64.0; // 64px
  
  // ============================================================================
  // SEMANTIC SPACING (Named by purpose)
  // ============================================================================
  
  /// Component padding
  static const double paddingTiny = xs;        // 8px
  static const double paddingSmall = sm;       // 12px
  static const double paddingMedium = md;      // 16px
  static const double paddingLarge = lg;       // 20px
  static const double paddingXLarge = xl;      // 24px
  static const double paddingXXLarge = xxl;    // 32px
  
  /// Screen padding (Samsung One UI: content pulled down for thumb reach)
  static const double screenHorizontal = xl;   // 24px
  static const double screenTop = xxxl;        // 40px (large top padding)
  static const double screenBottom = xl;       // 24px
  
  /// Card spacing
  static const double cardPadding = lg;        // 20px
  static const double cardPaddingLarge = xl;   // 24px
  static const double cardGap = md;            // 16px
  
  /// List item spacing
  static const double listItemPadding = md;    // 16px
  static const double listItemGap = sm;        // 12px
  
  /// Button padding
  static const double buttonPaddingVertical = md;    // 16px
  static const double buttonPaddingHorizontal = xl;  // 24px
  
  /// Input padding
  static const double inputPaddingVertical = md;     // 16px
  static const double inputPaddingHorizontal = md;   // 16px
  
  /// Section spacing
  static const double sectionGap = xl;         // 24px
  static const double sectionGapLarge = xxl;   // 32px
  
  // ============================================================================
  // EDGE INSETS PRESETS
  // ============================================================================
  
  /// All sides equal
  static const EdgeInsets all0 = EdgeInsets.zero;
  static const EdgeInsets all4 = EdgeInsets.all(xxs);
  static const EdgeInsets all8 = EdgeInsets.all(xs);
  static const EdgeInsets all12 = EdgeInsets.all(sm);
  static const EdgeInsets all16 = EdgeInsets.all(md);
  static const EdgeInsets all20 = EdgeInsets.all(lg);
  static const EdgeInsets all24 = EdgeInsets.all(xl);
  static const EdgeInsets all32 = EdgeInsets.all(xxl);
  
  /// Horizontal padding
  static const EdgeInsets h8 = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets h12 = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets h16 = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets h20 = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets h24 = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets h32 = EdgeInsets.symmetric(horizontal: xxl);
  
  /// Vertical padding
  static const EdgeInsets v8 = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets v12 = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets v16 = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets v20 = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets v24 = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets v32 = EdgeInsets.symmetric(vertical: xxl);
  
  /// Symmetric padding
  static const EdgeInsets symmetric12 = EdgeInsets.symmetric(horizontal: sm, vertical: xs);
  static const EdgeInsets symmetric16 = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets symmetric20 = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets symmetric24 = EdgeInsets.symmetric(horizontal: xl, vertical: lg);
  
  /// Screen padding (Samsung One UI style - large top)
  static const EdgeInsets screen = EdgeInsets.only(
    left: screenHorizontal,
    right: screenHorizontal,
    top: screenTop,
    bottom: screenBottom,
  );
  
  static const EdgeInsets screenHorizontalOnly = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
  );
  
  /// Card padding
  static const EdgeInsets card = EdgeInsets.all(cardPadding);
  static const EdgeInsets cardLarge = EdgeInsets.all(cardPaddingLarge);
  
  /// Button padding
  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: buttonPaddingHorizontal,
    vertical: buttonPaddingVertical,
  );
  
  /// Input padding
  static const EdgeInsets input = EdgeInsets.symmetric(
    horizontal: inputPaddingHorizontal,
    vertical: inputPaddingVertical,
  );
  
  // ============================================================================
  // GAP WIDGETS (for Flex layouts)
  // ============================================================================
  
  static const SizedBox gap4 = SizedBox(width: xxs, height: xxs);
  static const SizedBox gap8 = SizedBox(width: xs, height: xs);
  static const SizedBox gap12 = SizedBox(width: sm, height: sm);
  static const SizedBox gap16 = SizedBox(width: md, height: md);
  static const SizedBox gap20 = SizedBox(width: lg, height: lg);
  static const SizedBox gap24 = SizedBox(width: xl, height: xl);
  static const SizedBox gap32 = SizedBox(width: xxl, height: xxl);
  static const SizedBox gap40 = SizedBox(width: xxxl, height: xxxl);
  static const SizedBox gap48 = SizedBox(width: huge, height: huge);
  
  static const SizedBox gapH4 = SizedBox(width: xxs);
  static const SizedBox gapH8 = SizedBox(width: xs);
  static const SizedBox gapH12 = SizedBox(width: sm);
  static const SizedBox gapH16 = SizedBox(width: md);
  static const SizedBox gapH20 = SizedBox(width: lg);
  static const SizedBox gapH24 = SizedBox(width: xl);
  static const SizedBox gapH32 = SizedBox(width: xxl);
  
  static const SizedBox gapV4 = SizedBox(height: xxs);
  static const SizedBox gapV8 = SizedBox(height: xs);
  static const SizedBox gapV12 = SizedBox(height: sm);
  static const SizedBox gapV16 = SizedBox(height: md);
  static const SizedBox gapV20 = SizedBox(height: lg);
  static const SizedBox gapV24 = SizedBox(height: xl);
  static const SizedBox gapV32 = SizedBox(height: xxl);
  static const SizedBox gapV40 = SizedBox(height: xxxl);
}
