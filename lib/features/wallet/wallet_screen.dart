import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_sheets.dart';
import '../../app/core/app_constants.dart';
import '../../app/data/models/wallet_model.dart';
import '../../app/data/services/session_service.dart';
import '../../app/routes/app_routes.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/animations/premium_curves.dart';
import '../../design_system/animations/premium_durations.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../design_system/components/buttons/premium_button.dart';
import '../../app/widgets/common_widgets.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../design_system/tokens/premium_shadows.dart';
import '../../app/widgets/responsive.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionService.to;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'My Wallet',
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      body: ResponsiveCenter(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            PremiumSpacing.screenHorizontal,
            PremiumSpacing.md,
            PremiumSpacing.screenHorizontal,
            MediaQuery.of(context).padding.bottom + 24,
          ),
          children: [
            Obx(() => _PremiumBalanceHero(wallet: session.wallet.value)),
            const SizedBox(height: 24),
            _buildSectionHeader(
              context,
              isDark,
              'RECENT ACTIVITY',
              onTapSeeAll: () => Get.toNamed(AppRoutes.transactions),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final txs = session.transactions.take(3).toList();
              if (txs.isEmpty) {
                return _buildEmptyState(context, isDark);
              }
              return Column(
                children: [
                  for (final tx in txs) ...[
                    _MiniTxRow(tx: tx),
                    if (tx != txs.last) const SizedBox(height: 12),
                  ],
                ],
              );
            }),
            const SizedBox(height: 24),
            _buildSectionHeader(context, isDark, 'QUICK ACTIONS'),
            const SizedBox(height: 16),
            _buildQuickAction(
              context,
              isDark,
              icon: Icons.receipt_long_rounded,
              label: 'Transaction History',
              subtitle: 'View all your transactions',
              color: PremiumColors.primary,
              onTap: () => Get.toNamed(AppRoutes.transactions),
            ),
            const SizedBox(height: 12),
            _buildQuickAction(
              context,
              isDark,
              icon: Icons.shopping_bag_rounded,
              label: 'Order History',
              subtitle: 'Top-ups & purchases',
              color: PremiumColors.winning,
              onTap: () => Get.toNamed(AppRoutes.orders),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, isDark, 'HOW TO GUIDE'),
            const SizedBox(height: 16),
            _buildGuide(
              context,
              isDark,
              Icons.add_card_rounded,
              'How to Add Money?',
              const [
                'Open the Wallet and tap "Add Money".',
                'Enter the amount you want to deposit.',
                'Tap "Proceed to Payment" and complete it on the secure gateway.',
                'Your balance is credited instantly after a successful payment.',
              ],
            ),
            const SizedBox(height: 12),
            _buildGuide(
              context,
              isDark,
              Icons.sports_esports_rounded,
              'How to Join a Match?',
              const [
                'Pick a game mode from the Home screen.',
                'Open a match to review the rules and prize pool.',
                'Tap "Join Match", choose your slot type and enter player names.',
                'The entry fee is deducted and your slot is confirmed.',
              ],
            ),
            const SizedBox(height: 12),
            _buildGuide(
              context,
              isDark,
              Icons.account_balance_rounded,
              'How to Withdraw?',
              const [
                'Open the Wallet and tap "Withdraw".',
                'Choose bKash or Nagad and enter your wallet number.',
                'Enter an amount between ৳105 and ৳10000.',
                'Submit — your request is processed within 24 hours.',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    bool isDark,
    String title, {
    VoidCallback? onTapSeeAll,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: PremiumTypography.labelLarge.copyWith(
              color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (onTapSeeAll != null)
          GestureDetector(
            onTap: onTapSeeAll,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Text(
                  'See all',
                  style: PremiumTypography.label.copyWith(
                    color: PremiumColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: PremiumColors.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return PremiumCard(
      padding: PremiumSpacing.card,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'No transactions yet',
            style: PremiumTypography.body.copyWith(
              color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: PremiumTypography.bodyMedium.copyWith(
                    color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: PremiumTypography.caption.copyWith(
                    color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildGuide(
    BuildContext context,
    bool isDark,
    IconData icon,
    String title,
    List<String> steps,
  ) {
    return PremiumCard(
      onTap: () => AppSheet.show(context, title, steps),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PremiumColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: PremiumColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: PremiumTypography.bodyMedium.copyWith(
                color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
              ),
            ),
          ),
          Icon(
            Icons.help_outline_rounded,
            color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
          ),
        ],
      ),
    );
  }
}

class _PremiumBalanceHero extends StatelessWidget {
  final WalletModel wallet;
  
  const _PremiumBalanceHero({required this.wallet});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: PremiumDurations.slow,
      curve: PremiumCurves.emphasized,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: PremiumColors.primaryGradient,
          borderRadius: BorderRadius.circular(PremiumRadius.cardLarge),
          boxShadow: PremiumShadows.primaryGlow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      style: PremiumTypography.caption.copyWith(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
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
                        taka(wallet.availableBalance),
                        style: PremiumTypography.currencyLarge.copyWith(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildSubWallet(
                    context,
                    Icons.emoji_events_rounded,
                    'Winning',
                    taka(wallet.winningBalance),
                    PremiumColors.winningLight,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSubWallet(
                    context,
                    Icons.sports_esports_rounded,
                    'Gaming',
                    taka(wallet.availableBalance),
                    PremiumColors.gold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    Icons.add_rounded,
                    'Add Money',
                    () => Get.toNamed(AppRoutes.deposit),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    Icons.arrow_upward_rounded,
                    'Withdraw',
                    () => Get.toNamed(AppRoutes.withdraw),
                    isOutlined: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubWallet(
    BuildContext context,
    IconData icon,
    String label,
    String amount,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(PremiumRadius.md),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: PremiumTypography.caption.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: PremiumTypography.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed, {
    bool isOutlined = false,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : Colors.white,
          foregroundColor: isOutlined ? Colors.white : PremiumColors.primary,
          elevation: 0,
          side: isOutlined
              ? BorderSide(color: Colors.white.withOpacity(0.4), width: 1.5)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PremiumRadius.button),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: PremiumTypography.button.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniTxRow extends StatelessWidget {
  final TransactionModel tx;
  
  const _MiniTxRow({required this.tx});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool credit = tx.isCredit;
    final Color color = credit ? PremiumColors.winning : PremiumColors.danger;
    
    return PremiumCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              credit ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description.isEmpty ? tx.type.name : tx.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: PremiumTypography.bodyMedium.copyWith(
                    color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${tx.method} • ${shortDateTime(tx.date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: PremiumTypography.caption.copyWith(
                    color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${credit ? '+' : '-'}${taka(tx.amount)}',
            style: PremiumTypography.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
