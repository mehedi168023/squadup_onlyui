import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/core/app_toast.dart';
import '../../app/core/app_dialogs.dart';
import '../../app/core/app_sheets.dart';
import '../../app/core/app_constants.dart';
import '../../app/core/theme_controller.dart';
import '../../app/data/services/session_service.dart';
import '../../app/routes/app_routes.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../design_system/components/buttons/premium_button.dart';
import '../../app/widgets/brand_app_bar.dart';
import '../../app/widgets/common_widgets.dart';
import '../../app/widgets/responsive.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionService.to;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: const BrandAppBar(),
      body: ResponsiveCenter(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            PremiumSpacing.screenHorizontal,
            PremiumSpacing.md,
            PremiumSpacing.screenHorizontal,
            MediaQuery.of(context).padding.bottom + 84,
          ),
          children: [
            _PremiumProfileHeader(),
            const SizedBox(height: 24),
            _buildSectionHeader(context, isDark, 'ACCOUNT'),
            const SizedBox(height: 16),
            _buildNavTile(
              context,
              isDark,
              Icons.person_outline_rounded,
              'Edit Profile',
              null,
              PremiumColors.primary,
              () => Get.toNamed(AppRoutes.editProfile),
            ),
            const SizedBox(height: 12),
            _buildNavTile(
              context,
              isDark,
              Icons.account_balance_wallet_rounded,
              'My Wallet',
              null,
              PremiumColors.winning,
              () => Get.toNamed(AppRoutes.wallet),
            ),
            const SizedBox(height: 12),
            _buildNavTile(
              context,
              isDark,
              Icons.sports_esports_rounded,
              'My Matches',
              null,
              PremiumColors.gold,
              () => Get.toNamed(AppRoutes.myMatches),
            ),
            const SizedBox(height: 12),
            _buildNavTile(
              context,
              isDark,
              Icons.receipt_long_rounded,
              'Order History',
              'Top-ups & purchases',
              PremiumColors.info,
              () => Get.toNamed(AppRoutes.orders),
            ),
            const SizedBox(height: 12),
            _buildNavTile(
              context,
              isDark,
              Icons.leaderboard_rounded,
              'Top Players',
              null,
              PremiumColors.warning,
              () => Get.toNamed(AppRoutes.topPlayers),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, isDark, 'SETTINGS'),
            const SizedBox(height: 16),
            const _PremiumAppearanceTile(),
            const SizedBox(height: 24),
            _buildSectionHeader(context, isDark, 'MORE'),
            const SizedBox(height: 16),
            _buildNavTile(
              context,
              isDark,
              Icons.share_rounded,
              'Share App',
              null,
              PremiumColors.primary,
              () => _openShare(session),
            ),
            const SizedBox(height: 12),
            _buildNavTile(
              context,
              isDark,
              Icons.gavel_rounded,
              'Match Rules',
              null,
              PremiumColors.info,
              () => Get.toNamed(AppRoutes.matchRules),
            ),
            const SizedBox(height: 12),
            _buildNavTile(
              context,
              isDark,
              Icons.description_rounded,
              'Terms & Conditions',
              null,
              PremiumColors.warning,
              () => Get.toNamed(AppRoutes.terms),
            ),
            const SizedBox(height: 12),
            _buildNavTile(
              context,
              isDark,
              Icons.code_rounded,
              'Developer Profile',
              null,
              PremiumColors.primary,
              () => Get.toNamed(AppRoutes.developer),
            ),
            const SizedBox(height: 12),
            _buildNavTile(
              context,
              isDark,
              Icons.logout_rounded,
              'Logout',
              null,
              PremiumColors.danger,
              () => _confirmLogout(session),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isDark, String title) {
    return Text(
      title,
      style: PremiumTypography.labelLarge.copyWith(
        color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildNavTile(
    BuildContext context,
    bool isDark,
    IconData icon,
    String label,
    String? subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
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
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: PremiumTypography.caption.copyWith(
                      color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                    ),
                  ),
                ],
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

  Future<void> _confirmLogout(SessionService session) async {
    final ok = await AppDialogs.confirm(
      title: 'Logout',
      message: 'Are you sure you want to logout of your account?',
      confirmText: 'Logout',
      destructive: true,
    );
    if (ok) {
      session.logout();
      Get.offAllNamed(AppRoutes.login);
    }
  }
}

void _openShare(SessionService session) {
  final code = session.user.value?.referCode ?? 'SQUADUP';
  AppSheet.show(
    title: 'Share SquadUp',
    subtitle: 'Invite friends with your referral code and earn rewards.',
    child: _PremiumShareSheet(code: code),
  );
}

class _PremiumShareSheet extends StatelessWidget {
  final String code;
  
  const _PremiumShareSheet({required this.code});

  String get _invite =>
      'Join me on ${AppConstants.appName} 🎮 Play Free Fire tournaments and win cash! '
      'Use my referral code $code when you sign up.';

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3,
            borderRadius: BorderRadius.circular(PremiumRadius.md),
            border: Border.all(
              color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Referral Code',
                style: PremiumTypography.caption.copyWith(
                  color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      code,
                      style: PremiumTypography.h4.copyWith(
                        color: PremiumColors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded),
                    color: PremiumColors.primary,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      AppToast.success('Copied to clipboard');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        PremiumButton.primary(
          text: 'Share Invite Link',
          icon: const Icon(Icons.share_rounded),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: _invite));
            AppToast.success('Invite message copied to clipboard');
          },
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _PremiumAppearanceTile extends StatelessWidget {
  const _PremiumAppearanceTile();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Obx(() {
      final dark = theme.mode.value == ThemeMode.dark;
      return PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: PremiumColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: PremiumColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dark Mode',
                    style: PremiumTypography.bodyMedium.copyWith(
                      color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dark ? 'On' : 'Off',
                    style: PremiumTypography.caption.copyWith(
                      color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: dark,
              activeColor: PremiumColors.primary,
              onChanged: (_) => theme.toggle(),
            ),
          ],
        ),
      );
    });
  }
}

class _PremiumProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final session = SessionService.to;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumCard(
      padding: PremiumSpacing.card,
      child: Obx(() {
        final user = session.user.value;
        final wallet = session.wallet.value;
        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: PremiumColors.primaryGradient,
                    boxShadow: PremiumShadows.primaryGlow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      AppConstants.logo,
                      fit: BoxFit.cover,
                      cacheWidth: 180,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Guest',
                        style: PremiumTypography.h4.copyWith(
                          color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: PremiumColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: PremiumColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'UID: ${user?.uid ?? '#0'}',
                          style: PremiumTypography.labelSmall.copyWith(
                            color: PremiumColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3,
                borderRadius: BorderRadius.circular(PremiumRadius.md),
                border: Border.all(
                  color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Balance',
                          style: PremiumTypography.caption.copyWith(
                            color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          taka(wallet.availableBalance),
                          style: PremiumTypography.currencyMedium.copyWith(
                            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: PremiumColors.winning.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Winnings: ${taka(wallet.winningBalance)}',
                            style: PremiumTypography.labelSmall.copyWith(
                              color: PremiumColors.winning,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 90,
                    child: PremiumButton.primary(
                      text: 'ADD',
                      icon: const Icon(Icons.add_rounded, size: 18),
                      onPressed: () => Get.toNamed(AppRoutes.deposit),
                      size: PremiumButtonSize.small,
                      customColor: PremiumColors.winning,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStat(
                  context,
                  isDark,
                  Icons.sports_esports_rounded,
                  PremiumColors.gold,
                  '${user?.totalMatchesPlayed ?? 0}',
                  'Matches',
                ),
                const SizedBox(width: 12),
                _buildStat(
                  context,
                  isDark,
                  Icons.military_tech_rounded,
                  PremiumColors.gold,
                  '${user?.totalMatchesWon ?? 0}',
                  'Wins',
                ),
                const SizedBox(width: 12),
                _buildStat(
                  context,
                  isDark,
                  Icons.currency_exchange_rounded,
                  PremiumColors.gold,
                  taka(wallet.wonAmount),
                  'Earnings',
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStat(
    BuildContext context,
    bool isDark,
    IconData icon,
    Color color,
    String value,
    String label,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? PremiumColors.darkSurface2 : PremiumColors.lightSurface2,
          borderRadius: BorderRadius.circular(PremiumRadius.md),
          border: Border.all(
            color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: PremiumTypography.bodyMedium.copyWith(
                color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: PremiumTypography.captionSmall.copyWith(
                color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
