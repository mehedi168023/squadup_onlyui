import 'package:flutter/material.dart';
import '../../tokens/premium_colors.dart';
import '../../tokens/premium_typography.dart';
import '../../tokens/premium_spacing.dart';
import '../../tokens/premium_radius.dart';
import '../../animations/premium_curves.dart';
import '../../animations/premium_durations.dart';
import '../buttons/premium_button.dart';

/// Premium dialog component with Samsung One UI-inspired design
/// Smooth animations and premium styling
class PremiumDialog extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? message;
  final Widget? content;
  final List<PremiumDialogAction>? actions;
  final bool dismissible;
  final EdgeInsets? padding;
  
  const PremiumDialog({
    super.key,
    this.title,
    this.titleWidget,
    this.message,
    this.content,
    this.actions,
    this.dismissible = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: isDark ? PremiumColors.darkCardElevated : PremiumColors.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PremiumRadius.dialog),
      ),
      child: Container(
        padding: padding ?? PremiumSpacing.all24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (titleWidget != null)
              titleWidget!
            else if (title != null)
              Text(
                title!,
                style: PremiumTypography.h4.copyWith(
                  color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                ),
              ),
            if (title != null || titleWidget != null)
              const SizedBox(height: 16),
            if (content != null)
              content!
            else if (message != null)
              Text(
                message!,
                style: PremiumTypography.body.copyWith(
                  color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                ),
              ),
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!.map((action) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _buildActionButton(context, action),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton(BuildContext context, PremiumDialogAction action) {
    switch (action.type) {
      case PremiumDialogActionType.primary:
        return PremiumButton.primary(
          text: action.text,
          onPressed: () {
            if (action.dismissOnTap) Navigator.of(context).pop();
            action.onPressed?.call();
          },
          size: PremiumButtonSize.small,
        );
      case PremiumDialogActionType.secondary:
        return PremiumButton.secondary(
          text: action.text,
          onPressed: () {
            if (action.dismissOnTap) Navigator.of(context).pop();
            action.onPressed?.call();
          },
          size: PremiumButtonSize.small,
        );
      case PremiumDialogActionType.text:
        return PremiumButton.text(
          text: action.text,
          onPressed: () {
            if (action.dismissOnTap) Navigator.of(context).pop();
            action.onPressed?.call();
          },
          size: PremiumButtonSize.small,
        );
    }
  }
  
  /// Show alert dialog
  static Future<void> showAlert({
    required BuildContext context,
    String? title,
    required String message,
    String okText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => PremiumDialog(
        title: title,
        message: message,
        actions: [
          PremiumDialogAction(
            text: okText,
            type: PremiumDialogActionType.primary,
            dismissOnTap: true,
          ),
        ],
      ),
    );
  }
  
  /// Show confirmation dialog
  static Future<bool?> showConfirm({
    required BuildContext context,
    String? title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => PremiumDialog(
        title: title,
        message: message,
        actions: [
          PremiumDialogAction(
            text: cancelText,
            type: PremiumDialogActionType.text,
            onPressed: () => Navigator.of(context).pop(false),
            dismissOnTap: false,
          ),
          PremiumDialogAction(
            text: confirmText,
            type: PremiumDialogActionType.primary,
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop(true);
            },
            dismissOnTap: false,
          ),
        ],
      ),
    );
  }
  
  /// Show success dialog
  static Future<void> showSuccess({
    required BuildContext context,
    String title = 'Success',
    required String message,
    String okText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => PremiumDialog(
        titleWidget: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: PremiumColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: PremiumColors.success,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: PremiumTypography.h4.copyWith(
                color: context.text,
              ),
            ),
          ],
        ),
        message: message,
        actions: [
          PremiumDialogAction(
            text: okText,
            type: PremiumDialogActionType.primary,
            dismissOnTap: true,
          ),
        ],
      ),
    );
  }
  
  /// Show error dialog
  static Future<void> showError({
    required BuildContext context,
    String title = 'Error',
    required String message,
    String okText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => PremiumDialog(
        titleWidget: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: PremiumColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.error_rounded,
                color: PremiumColors.danger,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: PremiumTypography.h4.copyWith(
                color: context.text,
              ),
            ),
          ],
        ),
        message: message,
        actions: [
          PremiumDialogAction(
            text: okText,
            type: PremiumDialogActionType.primary,
            dismissOnTap: true,
          ),
        ],
      ),
    );
  }
}

/// Dialog action configuration
class PremiumDialogAction {
  final String text;
  final VoidCallback? onPressed;
  final PremiumDialogActionType type;
  final bool dismissOnTap;
  
  const PremiumDialogAction({
    required this.text,
    this.onPressed,
    this.type = PremiumDialogActionType.text,
    this.dismissOnTap = true,
  });
}

enum PremiumDialogActionType {
  primary,
  secondary,
  text,
}

/// Premium loading dialog
class PremiumLoadingDialog extends StatelessWidget {
  final String? message;
  
  const PremiumLoadingDialog({
    super.key,
    this.message,
  });
  
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PremiumLoadingDialog(message: message),
    );
  }
  
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: isDark ? PremiumColors.darkCardElevated : PremiumColors.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PremiumRadius.dialog),
      ),
      child: Padding(
        padding: PremiumSpacing.all24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(PremiumColors.primary),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 20),
              Text(
                message!,
                style: PremiumTypography.body.copyWith(
                  color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
