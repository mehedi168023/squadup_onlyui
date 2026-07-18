import 'package:flutter/material.dart';
import '../../tokens/premium_colors.dart';
import '../../tokens/premium_typography.dart';
import '../../tokens/premium_spacing.dart';
import '../../tokens/premium_radius.dart';

/// Premium bottom sheet component with Samsung One UI-inspired design
/// Smooth drag animations and premium styling
class PremiumBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final EdgeInsets? padding;
  final bool showHandle;
  final double? height;
  
  const PremiumBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.padding,
    this.showHandle = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkCardElevated : PremiumColors.lightCard,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(PremiumRadius.sheet),
          topRight: Radius.circular(PremiumRadius.sheet),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle)
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark 
                      ? PremiumColors.darkTextTertiary.withOpacity(0.3)
                      : PremiumColors.lightTextTertiary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: PremiumTypography.h4.copyWith(
                        color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          Flexible(
            child: Padding(
              padding: padding ?? PremiumSpacing.all24,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Show modal bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    EdgeInsets? padding,
    bool showHandle = true,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      builder: (context) => PremiumBottomSheet(
        title: title,
        padding: padding,
        showHandle: showHandle,
        height: height,
        child: child,
      ),
    );
  }
}

/// Action sheet with list of options
class PremiumActionSheet extends StatelessWidget {
  final String? title;
  final List<PremiumActionSheetItem> items;
  final bool showCancel;
  final String cancelText;
  
  const PremiumActionSheet({
    super.key,
    this.title,
    required this.items,
    this.showCancel = true,
    this.cancelText = 'Cancel',
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumBottomSheet(
      title: title,
      showHandle: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...items.map((item) => _buildActionItem(context, item, isDark)),
          if (showCancel) ...[
            const SizedBox(height: 8),
            _buildCancelButton(context, isDark),
          ],
        ],
      ),
    );
  }
  
  Widget _buildActionItem(BuildContext context, PremiumActionSheetItem item, bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        item.onTap?.call();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                color: item.isDestructive
                    ? PremiumColors.danger
                    : (isDark ? PremiumColors.darkText : PremiumColors.lightText),
                size: 24,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                item.title,
                style: PremiumTypography.body.copyWith(
                  color: item.isDestructive
                      ? PremiumColors.danger
                      : (isDark ? PremiumColors.darkText : PremiumColors.lightText),
                  fontWeight: item.isDestructive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (item.trailing != null) item.trailing!,
          ],
        ),
      ),
    );
  }
  
  Widget _buildCancelButton(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Center(
            child: Text(
              cancelText,
              style: PremiumTypography.bodyMedium.copyWith(
                color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// Show action sheet
  static Future<void> show({
    required BuildContext context,
    String? title,
    required List<PremiumActionSheetItem> items,
    bool showCancel = true,
    String cancelText = 'Cancel',
  }) {
    return PremiumBottomSheet.show(
      context: context,
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...items.map((item) {
            final bool isDark = Theme.of(context).brightness == Brightness.dark;
            return InkWell(
              onTap: () {
                Navigator.of(context).pop();
                item.onTap?.call();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        color: item.isDestructive
                            ? PremiumColors.danger
                            : (isDark ? PremiumColors.darkText : PremiumColors.lightText),
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: Text(
                        item.title,
                        style: PremiumTypography.body.copyWith(
                          color: item.isDestructive
                              ? PremiumColors.danger
                              : (isDark ? PremiumColors.darkText : PremiumColors.lightText),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Action sheet item configuration
class PremiumActionSheetItem {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isDestructive;
  final Widget? trailing;
  
  const PremiumActionSheetItem({
    required this.title,
    this.icon,
    this.onTap,
    this.isDestructive = false,
    this.trailing,
  });
}
