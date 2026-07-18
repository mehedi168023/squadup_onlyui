import 'package:flutter/material.dart';
import '../../tokens/premium_colors.dart';
import '../../tokens/premium_typography.dart';
import '../../tokens/premium_spacing.dart';
import '../../tokens/premium_radius.dart';
import '../../animations/premium_curves.dart';
import '../../animations/premium_durations.dart';

/// Premium button component with Samsung One UI-inspired design
/// Includes all button variants with smooth animations
class PremiumButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final PremiumButtonVariant variant;
  final PremiumButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? customColor;
  
  const PremiumButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = PremiumButtonVariant.primary,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customColor,
  });
  
  const PremiumButton.primary({
    this.customColor,
    super.key,
    required this.text,
    this.onPressed,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : variant = PremiumButtonVariant.primary,

  
  const PremiumButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : variant = PremiumButtonVariant.secondary,
       customColor = null;
  
  const PremiumButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : variant = PremiumButtonVariant.outlined,
       customColor = null;
  
  const PremiumButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : variant = PremiumButtonVariant.text,
       customColor = null;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;
    
    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      } : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: PremiumDurations.buttonPress,
        curve: PremiumCurves.snappy,
        child: AnimatedContainer(
          duration: PremiumDurations.fast,
          curve: PremiumCurves.standard,
          width: widget.isFullWidth ? double.infinity : null,
          height: _getHeight(),
          padding: _getPadding(),
          decoration: _getDecoration(isDark, isEnabled),
          child: Center(
            child: widget.isLoading
                ? _buildLoader()
                : _buildContent(),
          ),
        ),
      ),
    );
  }
  
  Widget _buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          IconTheme(
            data: IconThemeData(
              color: _getTextColor(),
              size: _getIconSize(),
            ),
            child: widget.icon!,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          widget.text,
          style: _getTextStyle(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _buildLoader() {
    return SizedBox(
      width: _getLoaderSize(),
      height: _getLoaderSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
      ),
    );
  }
  
  double _getHeight() {
    switch (widget.size) {
      case PremiumButtonSize.small:
        return 44;
      case PremiumButtonSize.medium:
        return 52;
      case PremiumButtonSize.large:
        return 60;
    }
  }
  
  EdgeInsets _getPadding() {
    switch (widget.size) {
      case PremiumButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case PremiumButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
      case PremiumButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }
  
  TextStyle _getTextStyle() {
    final baseStyle = widget.size == PremiumButtonSize.large
        ? PremiumTypography.buttonLarge
        : widget.size == PremiumButtonSize.small
            ? PremiumTypography.buttonSmall
            : PremiumTypography.button;
    
    return baseStyle.copyWith(color: _getTextColor());
  }
  
  double _getIconSize() {
    switch (widget.size) {
      case PremiumButtonSize.small:
        return 18;
      case PremiumButtonSize.medium:
        return 20;
      case PremiumButtonSize.large:
        return 24;
    }
  }
  
  double _getLoaderSize() {
    switch (widget.size) {
      case PremiumButtonSize.small:
        return 16;
      case PremiumButtonSize.medium:
        return 20;
      case PremiumButtonSize.large:
        return 24;
    }
  }
  
  Color _getTextColor() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;
    
    if (!isEnabled) {
      return isDark ? PremiumColors.darkTextDisabled : PremiumColors.lightTextDisabled;
    }
    
    switch (widget.variant) {
      case PremiumButtonVariant.primary:
        return Colors.white;
      case PremiumButtonVariant.secondary:
        return isDark ? PremiumColors.darkText : PremiumColors.lightText;
      case PremiumButtonVariant.outlined:
        return isDark ? PremiumColors.darkText : PremiumColors.lightText;
      case PremiumButtonVariant.text:
        return widget.customColor ?? PremiumColors.primary;
    }
  }
  
  BoxDecoration _getDecoration(bool isDark, bool isEnabled) {
    Color bgColor;
    Color? borderColor;
    
    if (!isEnabled) {
      bgColor = widget.variant == PremiumButtonVariant.text
          ? Colors.transparent
          : (isDark ? PremiumColors.darkSurface3 : PremiumColors.lightBorderSubtle);
      borderColor = widget.variant == PremiumButtonVariant.outlined
          ? (isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder).withOpacity(0.5)
          : null;
    } else {
      switch (widget.variant) {
        case PremiumButtonVariant.primary:
          bgColor = widget.customColor ?? PremiumColors.primary;
          break;
        case PremiumButtonVariant.secondary:
          bgColor = isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3;
          break;
        case PremiumButtonVariant.outlined:
          bgColor = Colors.transparent;
          borderColor = isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder;
          break;
        case PremiumButtonVariant.text:
          bgColor = Colors.transparent;
          break;
      }
    }
    
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(PremiumRadius.button),
      border: borderColor != null
          ? Border.all(color: borderColor, width: 1.5)
          : null,
    );
  }
}

enum PremiumButtonVariant {
  primary,
  secondary,
  outlined,
  text,
}

enum PremiumButtonSize {
  small,
  medium,
  large,
}

/// Icon-only button
class PremiumIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? tooltip;
  
  const PremiumIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 48,
    this.tooltip,
  });

  @override
  State<PremiumIconButton> createState() => _PremiumIconButtonState();
}

class _PremiumIconButtonState extends State<PremiumIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isEnabled = widget.onPressed != null;
    
    final iconColor = widget.color ??
        (isEnabled
            ? (isDark ? PremiumColors.darkText : PremiumColors.lightText)
            : (isDark ? PremiumColors.darkTextDisabled : PremiumColors.lightTextDisabled));
    
    final button = GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      } : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: PremiumDurations.buttonPress,
        curve: PremiumCurves.snappy,
        child: AnimatedContainer(
          duration: PremiumDurations.fast,
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(widget.size / 4),
          ),
          child: Icon(
            widget.icon,
            color: iconColor,
            size: widget.size * 0.5,
          ),
        ),
      ),
    );
    
    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }
    
    return button;
  }
}
