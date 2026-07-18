import 'package:flutter/animation.dart';

/// Premium animation curves inspired by Samsung One UI
/// Natural, fluid motion with subtle elasticity
class PremiumCurves {
  PremiumCurves._();

  // ============================================================================
  // STANDARD EASING CURVES
  // ============================================================================
  
  /// Standard ease - default for most transitions
  static const Curve ease = Curves.easeInOut;
  
  /// Ease in - element entering
  static const Curve easeIn = Curves.easeIn;
  
  /// Ease out - element exiting
  static const Curve easeOut = Curves.easeOut;
  
  // ============================================================================
  // PREMIUM CUSTOM CURVES (Samsung One UI inspired)
  // ============================================================================
  
  /// Sharp entrance - quick acceleration, smooth deceleration
  static const Curve sharpIn = Cubic(0.4, 0.0, 0.2, 1.0);
  
  /// Soft exit - smooth acceleration, quick deceleration
  static const Curve softOut = Cubic(0.0, 0.0, 0.2, 1.0);
  
  /// Standard motion - balanced, natural feel
  static const Curve standard = Cubic(0.4, 0.0, 0.2, 1.0);
  
  /// Emphasized motion - more pronounced acceleration
  static const Curve emphasized = Cubic(0.4, 0.0, 0.0, 1.0);
  
  /// Decelerated motion - slow start, natural end
  static const Curve decelerated = Cubic(0.0, 0.0, 0.2, 1.0);
  
  /// Accelerated motion - fast start, slow end
  static const Curve accelerated = Cubic(0.4, 0.0, 1.0, 1.0);
  
  // ============================================================================
  // SPRING / ELASTIC CURVES
  // ============================================================================
  
  /// Subtle spring - gentle bounce
  static const Curve springSubtle = Cubic(0.34, 1.56, 0.64, 1.0);
  
  /// Standard spring - medium bounce
  static const Curve spring = Curves.elasticOut;
  
  /// Bouncy spring - pronounced bounce
  static const Curve springBouncy = Curves.bounceOut;
  
  // ============================================================================
  // EXPRESSIVE CURVES (for hero moments)
  // ============================================================================
  
  /// Overshoot - slight overshoot and settle
  static const Curve overshoot = Cubic(0.34, 1.56, 0.64, 1.0);
  
  /// Anticipate - pulls back before moving forward
  static const Curve anticipate = Cubic(0.36, 0.0, 0.66, -0.56);
  
  /// Overshoot and settle
  static const Curve overshootSettle = Cubic(0.175, 0.885, 0.32, 1.275);
  
  // ============================================================================
  // SPECIAL CURVES
  // ============================================================================
  
  /// Smooth - silky smooth motion
  static const Curve smooth = Cubic(0.25, 0.1, 0.25, 1.0);
  
  /// Snappy - quick and responsive
  static const Curve snappy = Cubic(0.5, 0.0, 0.5, 1.0);
  
  /// Linear - constant speed (use sparingly)
  static const Curve linear = Curves.linear;
  
  // ============================================================================
  // CONTEXT-SPECIFIC CURVES
  // ============================================================================
  
  /// Navigation transitions
  static const Curve navigation = standard;
  
  /// Button press
  static const Curve buttonPress = snappy;
  
  /// Card expansion
  static const Curve cardExpand = emphasized;
  
  /// Modal appearance
  static const Curve modal = decelerated;
  
  /// Drawer slide
  static const Curve drawer = standard;
  
  /// Page scroll
  static const Curve scroll = decelerated;
  
  /// Fade transitions
  static const Curve fade = ease;
  
  /// Scale transitions
  static const Curve scale = emphasized;
  
  /// Slide transitions
  static const Curve slide = standard;
}
