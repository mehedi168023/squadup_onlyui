import 'package:flutter/animation.dart';

/// Premium animation durations inspired by Samsung One UI
/// Tuned for 120 FPS displays with natural timing
class PremiumDurations {
  PremiumDurations._();

  // ============================================================================
  // BASE DURATIONS (milliseconds)
  // ============================================================================
  
  /// Instant - no animation (0ms)
  static const Duration instant = Duration.zero;
  
  /// Ultra fast - micro interactions (100ms)
  static const Duration ultraFast = Duration(milliseconds: 100);
  
  /// Very fast - quick feedback (150ms)
  static const Duration veryFast = Duration(milliseconds: 150);
  
  /// Fast - snappy transitions (200ms)
  static const Duration fast = Duration(milliseconds: 200);
  
  /// Normal - standard transitions (300ms)
  static const Duration normal = Duration(milliseconds: 300);
  
  /// Medium - moderate transitions (400ms)
  static const Duration medium = Duration(milliseconds: 400);
  
  /// Slow - deliberate transitions (500ms)
  static const Duration slow = Duration(milliseconds: 500);
  
  /// Very slow - hero moments (600ms)
  static const Duration verySlow = Duration(milliseconds: 600);
  
  /// Ultra slow - dramatic reveals (800ms)
  static const Duration ultraSlow = Duration(milliseconds: 800);
  
  // ============================================================================
  // SEMANTIC DURATIONS (by interaction type)
  // ============================================================================
  
  /// Button press/tap feedback
  static const Duration buttonPress = ultraFast;
  
  /// Button release
  static const Duration buttonRelease = veryFast;
  
  /// Ripple effect
  static const Duration ripple = medium;
  
  /// Hover feedback
  static const Duration hover = veryFast;
  
  /// Focus indicator
  static const Duration focus = fast;
  
  // ============================================================================
  // NAVIGATION DURATIONS
  // ============================================================================
  
  /// Page transition
  static const Duration pageTransition = normal;
  
  /// Modal appearance
  static const Duration modalIn = medium;
  
  /// Modal dismissal
  static const Duration modalOut = fast;
  
  /// Bottom sheet slide
  static const Duration bottomSheet = medium;
  
  /// Drawer slide
  static const Duration drawer = normal;
  
  /// Tab switch
  static const Duration tabSwitch = fast;
  
  // ============================================================================
  // COMPONENT DURATIONS
  // ============================================================================
  
  /// Card expansion
  static const Duration cardExpand = medium;
  
  /// Card collapse
  static const Duration cardCollapse = fast;
  
  /// List item appearance
  static const Duration listItem = fast;
  
  /// Dialog appearance
  static const Duration dialogIn = medium;
  
  /// Dialog dismissal
  static const Duration dialogOut = fast;
  
  /// Snackbar/toast
  static const Duration snackbar = fast;
  
  /// Tooltip
  static const Duration tooltip = veryFast;
  
  // ============================================================================
  // ANIMATED CONTENT DURATIONS
  // ============================================================================
  
  /// Fade transitions
  static const Duration fade = fast;
  
  /// Scale transitions
  static const Duration scale = fast;
  
  /// Slide transitions
  static const Duration slide = normal;
  
  /// Rotation
  static const Duration rotation = medium;
  
  /// Container transform
  static const Duration containerTransform = medium;
  
  // ============================================================================
  // SPECIAL EFFECTS DURATIONS
  // ============================================================================
  
  /// Shimmer/skeleton loading (per cycle)
  static const Duration shimmer = Duration(milliseconds: 1500);
  
  /// Number counter animation
  static const Duration counter = slow;
  
  /// Progress indicator
  static const Duration progress = normal;
  
  /// Loading spinner
  static const Duration spinner = Duration(milliseconds: 1000);
  
  /// Success/error animation
  static const Duration feedback = medium;
  
  /// Confetti/celebration
  static const Duration celebration = Duration(milliseconds: 2000);
}
