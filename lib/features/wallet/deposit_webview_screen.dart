import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/data/models/heads_up_notification.dart';
import '../../app/data/services/notification_service.dart';
import '../../app/data/services/session_service.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/buttons/premium_button.dart';
import '../../design_system/animations/premium_curves.dart';
import '../../design_system/animations/premium_durations.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../app/widgets/responsive.dart';

class DepositWebviewScreen extends StatefulWidget {
  const DepositWebviewScreen({super.key});

  @override
  State<DepositWebviewScreen> createState() => _DepositWebviewScreenState();
}

class _DepositWebviewScreenState extends State<DepositWebviewScreen> {
  late final double amount = Get.arguments as double;
  bool _processing = false;

  Future<void> _pay() async {
    setState(() => _processing = true);
    await SessionService.to.deposit(amount);
    if (!mounted) return;
    setState(() => _processing = false);
    Get.back();
    Get.back();
    NotificationService.to.showHeadsUp(
      HeadsUpNotification(
        id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Payment Success ✅',
        message: '${taka(amount)} added to your wallet.',
        kind: NotifKind.action,
        priority: NotifPriority.high,
        icon: 'wallet',
        actionText: 'Open Wallet',
        actionTarget: 'wallet',
        sound: 'coin',
      ),
      osNotify: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text('Secure Payment', style: PremiumTypography.h3.copyWith(
          color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
        )),
      ),
      body: ResponsiveCenter(
        child: Padding(
          padding: PremiumSpacing.all16,
          child: Column(
            children: [
              _buildAddressBar(context, isDark),
              const Spacer(),
              TweenAnimationBuilder<double>(
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
                child: _PremiumPaymentCard(amount: amount),
              ),
              const SizedBox(height: 20),
              _buildTrustRow(context, isDark),
              const Spacer(),
              PremiumButton.primary(
                text: 'Confirm Payment',
                icon: const Icon(Icons.lock_rounded),
                onPressed: _processing ? null : _pay,
                isLoading: _processing,
                isFullWidth: true,
                customColor: PremiumColors.winning,
              ),
              const SizedBox(height: 12),
              PremiumButton.secondary(
                text: 'Cancel',
                onPressed: () => Get.back(),
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkCard : PremiumColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_rounded, color: PremiumColors.winning, size: 16),
          const SizedBox(width: 8),
          Text('secure.squadup.gg/pay', style: PremiumTypography.bodySmall.copyWith(color: context.textSecondary)),
          const Spacer(),
          Icon(Icons.refresh_rounded, color: context.textTertiary, size: 16),
        ],
      ),
    );
  }

  Widget _buildTrustRow(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTrustChip(context, Icons.verified_user_rounded, 'Secure'),
        const SizedBox(width: 10),
        _buildTrustChip(context, Icons.bolt_rounded, 'Instant'),
        const SizedBox(width: 10),
        _buildTrustChip(context, Icons.shield_rounded, 'Encrypted'),
      ],
    );
  }

  Widget _buildTrustChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: PremiumColors.winning),
          const SizedBox(width: 6),
          Text(label, style: PremiumTypography.labelSmall.copyWith(color: context.textSecondary)),
        ],
      ),
    );
  }
}

class _PremiumPaymentCard extends StatelessWidget {
  final double amount;
  const _PremiumPaymentCard({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PremiumRadius.cardLarge),
        boxShadow: PremiumShadows.primaryGlow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PremiumRadius.cardLarge),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2E55C4), Color(0xFF1B2E63), Color(0xFF0E1830)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Positioned(top: -40, left: -40,
              child: Container(width: 140, height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(bottom: -40, right: -30,
              child: Container(width: 110, height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Icon(Icons.lock_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text('SquadUp Pay', style: PremiumTypography.bodyMedium.copyWith(
                        color: Colors.white, letterSpacing: 0.4)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: PremiumColors.gold.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: PremiumColors.gold.withOpacity(0.5)),
                        ),
                        child: Text('DEMO', style: PremiumTypography.labelSmall.copyWith(
                          color: PremiumColors.gold, fontWeight: FontWeight.w800, letterSpacing: 1)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Total Payable', style: PremiumTypography.caption.copyWith(
                    color: Colors.white.withOpacity(0.7))),
                  const SizedBox(height: 6),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    curve: PremiumCurves.emphasized,
                    builder: (context, value, child) {
                      return Opacity(opacity: value, child: child);
                    },
                    child: Text(taka(amount), style: PremiumTypography.currencyLarge.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.white.withOpacity(0.15), height: 1, thickness: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet_rounded, size: 16, color: Colors.white.withOpacity(0.7)),
                      const SizedBox(width: 8),
                      Text('Paying to SquadUp Wallet', style: PremiumTypography.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.8))),
                      const Spacer(),
                      Text('256-bit SSL', style: PremiumTypography.labelSmall.copyWith(
                        color: PremiumColors.winning, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
