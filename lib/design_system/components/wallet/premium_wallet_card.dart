import 'package:flutter/material.dart';
import '../../tokens/premium_colors.dart';
import '../../tokens/premium_typography.dart';
import '../../tokens/premium_spacing.dart';
import '../../tokens/premium_radius.dart';
import '../../animations/premium_curves.dart';
import '../../animations/premium_durations.dart';

/// Premium wallet balance card with Samsung One UI-inspired design
/// Animated balance display with gradient background
class PremiumWalletBalanceCard extends StatelessWidget {
  final String balance;
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Gradient? gradient;
  final bool showBalance;
  
  const PremiumWalletBalanceCard({
    super.key,
    required this.balance,
    this.label = 'Total Balance',
    this.onTap,
    this.icon,
    this.gradient,
    this.showBalance = true,
  });
  
  const PremiumWalletBalanceCard.primary({
    super.key,
    required this.balance,
    this.label = 'Total Balance',
    this.onTap,
    this.icon,
    this.showBalance = true,
  }) : gradient = PremiumColors.primaryGradient;
  
  const PremiumWalletBalanceCard.winning({
    super.key,
    required this.balance,
    this.label = 'Winning Wallet',
    this.onTap,
    this.icon,
    this.showBalance = true,
  }) : gradient = PremiumColors.winningGradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: PremiumSpacing.cardLarge,
        decoration: BoxDecoration(
          gradient: gradient ?? PremiumColors.primaryGradient,
          borderRadius: BorderRadius.circular(PremiumRadius.cardLarge),
          boxShadow: const [
            BoxShadow(
              color: Color(0x337C3AED),
              offset: Offset(0, 8),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: PremiumTypography.caption.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    color: Colors.white.withOpacity(0.9),
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: PremiumDurations.slow,
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
              child: Text(
                showBalance ? balance : '••••••',
                style: PremiumTypography.currencyLarge.copyWith(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact wallet selector card
class PremiumWalletSelectorCard extends StatelessWidget {
  final String title;
  final String balance;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;
  
  const PremiumWalletSelectorCard({
    super.key,
    required this.title,
    required this.balance,
    required this.icon,
    required this.color,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: PremiumDurations.fast,
        curve: PremiumCurves.standard,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.15)
              : (isDark ? PremiumColors.darkCard : PremiumColors.lightCard),
          borderRadius: BorderRadius.circular(PremiumRadius.card),
          border: Border.all(
            color: isSelected ? color : (isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: PremiumTypography.labelSmall.copyWith(
                      color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    balance,
                    style: PremiumTypography.h6.copyWith(
                      color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// Transaction item component
class PremiumTransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;
  final IconData icon;
  final String date;
  final VoidCallback? onTap;
  
  const PremiumTransactionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.icon,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color amountColor = isCredit ? PremiumColors.success : PremiumColors.danger;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(PremiumRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: PremiumTypography.bodyMedium.copyWith(
                      color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: PremiumTypography.captionSmall.copyWith(
                      color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}$amount',
                  style: PremiumTypography.bodyMedium.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: PremiumTypography.captionSmall.copyWith(
                    color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
