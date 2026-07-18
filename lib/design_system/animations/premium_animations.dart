import 'package:flutter/material.dart';
import 'premium_curves.dart';
import 'premium_durations.dart';

/// Premium animation helpers and constants
/// Complete animation system for fluid, 120 FPS motion
class PremiumAnimations {
  PremiumAnimations._();

  // ============================================================================
  // FADE ANIMATIONS
  // ============================================================================
  
  /// Standard fade in
  static Widget fadeIn({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? begin,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin ?? 0.0, end: 1.0),
      duration: duration ?? PremiumDurations.fade,
      curve: curve ?? PremiumCurves.fade,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: child,
    );
  }
  
  /// Fade with slide up
  static Widget fadeSlideUp({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double offset = 20.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration ?? PremiumDurations.normal,
      curve: curve ?? PremiumCurves.emphasized,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, offset * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
  
  // ============================================================================
  // SCALE ANIMATIONS
  // ============================================================================
  
  /// Scale in animation
  static Widget scaleIn({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? begin,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin ?? 0.8, end: 1.0),
      duration: duration ?? PremiumDurations.scale,
      curve: curve ?? PremiumCurves.emphasized,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: Opacity(
          opacity: value,
          child: child,
        ),
      ),
      child: child,
    );
  }
  
  // ============================================================================
  // STAGGERED LIST ANIMATIONS
  // ============================================================================
  
  /// Staggered fade-in for list items
  static Widget staggeredListItem({
    required Widget child,
    required int index,
    int itemsPerBatch = 3,
    Duration? itemDuration,
    Duration? staggerDelay,
  }) {
    final delay = (index % itemsPerBatch) * 
      (staggerDelay ?? const Duration(milliseconds: 50));
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: itemDuration ?? PremiumDurations.fast,
      curve: PremiumCurves.emphasized,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Animated container with premium defaults
class PremiumAnimatedContainer extends StatelessWidget {
  final Widget? child;
  final Duration duration;
  final Curve curve;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final AlignmentGeometry? alignment;
  
  const PremiumAnimatedContainer({
    super.key,
    this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = PremiumCurves.standard,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      color: color,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: decoration,
      alignment: alignment,
      child: child,
    );
  }
}

/// Animated opacity with premium defaults
class PremiumAnimatedOpacity extends StatelessWidget {
  final Widget child;
  final double opacity;
  final Duration duration;
  final Curve curve;
  
  const PremiumAnimatedOpacity({
    super.key,
    required this.child,
    required this.opacity,
    this.duration = const Duration(milliseconds: 200),
    this.curve = PremiumCurves.fade,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}

/// Premium button press animation wrapper
class PremiumPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double pressScale;
  final Duration duration;
  final Curve curve;
  
  const PremiumPressable({
    super.key,
    required this.child,
    this.onPressed,
    this.pressScale = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.curve = PremiumCurves.snappy,
  });

  @override
  State<PremiumPressable> createState() => _PremiumPressableState();
}

class _PremiumPressableState extends State<PremiumPressable> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? widget.pressScale : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}

/// Shimmer loading effect
class PremiumShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;
  
  const PremiumShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFF1A1A24),
    this.highlightColor = const Color(0xFF22222E),
  });

  @override
  State<PremiumShimmer> createState() => _PremiumShimmerState();
}

class _PremiumShimmerState extends State<PremiumShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, -0.3),
              end: Alignment(1.0 + _controller.value * 2, 0.3),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
