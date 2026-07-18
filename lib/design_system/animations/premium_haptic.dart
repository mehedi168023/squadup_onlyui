import 'package:flutter/services.dart';

/// Premium haptic feedback utility for micro-interactions
/// Provides tactile feedback for every user interaction
class PremiumHaptic {
  PremiumHaptic._();

  /// Light impact - button taps, card selections
  static void light() => HapticFeedback.lightImpact();

  /// Medium impact - tab switches, option selections
  static void medium() => HapticFeedback.mediumImpact();

  /// Heavy impact - confirmations, important actions
  static void heavy() => HapticFeedback.heavyImpact();

  /// Selection click - picker/dropdown selections
  static void selection() => HapticFeedback.selectionClick();

  /// Success feedback - completed operations
  static void success() {
    HapticFeedback.mediumImpact();
  }

  /// Error feedback - failed operations
  static void error() {
    HapticFeedback.heavyImpact();
  }

  /// Button press sequence
  static void buttonPress() {
    light();
  }

  /// Navigation tab switch
  static void tabSwitch() {
    light();
  }

  /// Refresh action
  static void refresh() {
    medium();
  }

  /// Confirm destructive action
  static void destructive() {
    heavy();
  }
}

/// Wrapper widget that provides haptic feedback on tap
class PremiumHapticWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final PremiumHapticType hapticType;

  const PremiumHapticWidget({
    super.key,
    required this.child,
    this.onTap,
    this.hapticType = PremiumHapticType.light,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (hapticType) {
          case PremiumHapticType.light:
            PremiumHaptic.light();
            break;
          case PremiumHapticType.medium:
            PremiumHaptic.medium();
            break;
          case PremiumHapticType.heavy:
            PremiumHaptic.heavy();
            break;
          case PremiumHapticType.selection:
            PremiumHaptic.selection();
            break;
        }
        onTap?.call();
      },
      child: child,
    );
  }
}

enum PremiumHapticType {
  light,
  medium,
  heavy,
  selection,
}
