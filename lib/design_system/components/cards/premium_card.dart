import 'package:flutter/material.dart';
import '../../tokens/premium_colors.dart';
import '../../tokens/premium_spacing.dart';
import '../../tokens/premium_radius.dart';
import '../../tokens/premium_shadows.dart';
import '../../animations/premium_curves.dart';
import '../../animations/premium_durations.dart';

/// Premium card component with Samsung One UI-inspired design
/// Base card with various elevation and interaction states
class PremiumCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool elevated;
  final bool interactive;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? shadows;
  
  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.color,
    this.elevated = false,
    this.interactive = true,
    this.borderRadius,
    this.border,
    this.shadows,
  });

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isInteractive = widget.onTap != null || widget.onLongPress != null;
    
    final cardColor = widget.color ??
        (widget.elevated
            ? (isDark ? PremiumColors.darkCardElevated : PremiumColors.lightCardElevated)
            : (isDark ? PremiumColors.darkCard : PremiumColors.lightCard));
    
    final cardShadows = widget.shadows ??
        (widget.elevated
            ? (isDark ? PremiumShadows.darkCardElevated : PremiumShadows.lightCardElevated)
            : (isDark ? PremiumShadows.darkCard : PremiumShadows.lightCard));
    
    Widget card = AnimatedContainer(
      duration: PremiumDurations.fast,
      curve: PremiumCurves.standard,
      margin: widget.margin,
      padding: widget.padding ?? PremiumSpacing.card,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: widget.borderRadius ?? PremiumRadius.r20,
        border: widget.border,
        boxShadow: cardShadows,
      ),
      child: widget.child,
    );
    
    if (isInteractive && widget.interactive) {
      return GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        onLongPress: widget.onLongPress,
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: PremiumDurations.buttonPress,
          curve: PremiumCurves.snappy,
          child: card,
        ),
      );
    }
    
    return card;
  }
}

/// Glassmorphism card with blur effect
class PremiumGlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double opacity;
  
  const PremiumGlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumCard(
      onTap: onTap,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      color: isDark
          ? PremiumColors.glassWhite.withOpacity(opacity)
          : PremiumColors.overlayDarkLight.withOpacity(opacity),
      border: Border.all(
        color: isDark
            ? PremiumColors.glassBorder
            : PremiumColors.lightBorder.withOpacity(0.3),
        width: 1,
      ),
      shadows: const [],
      child: child,
    );
  }
}

/// Gradient card
class PremiumGradientCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Gradient gradient;
  
  const PremiumGradientCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.gradient = PremiumColors.primaryGradient,
  });
  
  const PremiumGradientCard.primary({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
  }) : gradient = PremiumColors.primaryGradient;
  
  const PremiumGradientCard.success({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
  }) : gradient = PremiumColors.successGradient;
  
  const PremiumGradientCard.winning({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
  }) : gradient = PremiumColors.winningGradient;
  
  const PremiumGradientCard.gold({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
  }) : gradient = PremiumColors.goldGradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding ?? PremiumSpacing.card,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius ?? PremiumRadius.r20,
          boxShadow: context.shadowCard,
        ),
        child: child,
      ),
    );
  }
}

/// Outlined card with border
class PremiumOutlinedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double borderWidth;
  
  const PremiumOutlinedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumCard(
      onTap: onTap,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      color: Colors.transparent,
      border: Border.all(
        color: borderColor ?? (isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder),
        width: borderWidth,
      ),
      shadows: const [],
      child: child,
    );
  }
}

/// Info card with colored accent
class PremiumInfoCard extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool showAccentBorder;
  
  const PremiumInfoCard({
    super.key,
    required this.child,
    required this.accentColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.showAccentBorder = true,
  });
  
  const PremiumInfoCard.primary({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.showAccentBorder = true,
  }) : accentColor = PremiumColors.primary;
  
  const PremiumInfoCard.success({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.showAccentBorder = true,
  }) : accentColor = PremiumColors.success;
  
  const PremiumInfoCard.warning({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.showAccentBorder = true,
  }) : accentColor = PremiumColors.warning;
  
  const PremiumInfoCard.danger({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.showAccentBorder = true,
  }) : accentColor = PremiumColors.danger;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      border: showAccentBorder
          ? Border(
              left: BorderSide(
                color: accentColor,
                width: 4,
              ),
            )
          : null,
      interactive: false,
      child: child,
    );
  }
}
