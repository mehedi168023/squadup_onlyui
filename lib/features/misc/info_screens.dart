import 'package:flutter/material.dart';
import '../../app/core/app_constants.dart';
import '../../app/core/app_links.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../app/widgets/common_widgets.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  static const _terms =
      '''By using ${AppConstants.appName}, you agree to the following terms:

1. You must be 18 years or older to participate in paid tournaments.
2. Entry fees are non-refundable once a match has started.
3. Any form of hacking, cheating, or use of unauthorized panels results in a permanent ban.
4. Winnings are credited to your wallet and can be withdrawn via the supported channels (bKash / Nagad).
5. The minimum withdrawal amount is ৳105 and the maximum is ৳10000.
6. Room IDs and passwords are shared only with registered participants.
7. The decision of match admins is final in all disputes.

For full details visit squadup.gg/privacy''';

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'Terms & Conditions',
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          PremiumSpacing.screenHorizontal,
          PremiumSpacing.md,
          PremiumSpacing.screenHorizontal,
          MediaQuery.of(context).padding.bottom + 24,
        ),
        child: PremiumCard(
          padding: PremiumSpacing.cardLarge,
          child: Text(
            _terms,
            style: PremiumTypography.body.copyWith(
              color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
              height: 1.7,
            ),
          ),
        ),
      ),
    );
  }
}

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'Developer Profile',
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: PremiumSpacing.all24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: PremiumColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: PremiumShadows.primaryGlow,
                ),
                child: const Icon(
                  Icons.code_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Mehedi',
                style: PremiumTypography.h2.copyWith(
                  color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'App Developer & Esports Platform',
                style: PremiumTypography.body.copyWith(
                  color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const _PremiumContactTile(
                icon: Icons.telegram_rounded,
                label: 'Telegram',
                value: '@mehedi',
                url: 'https://t.me/mehedi',
              ),
              const SizedBox(height: 12),
              const _PremiumContactTile(
                icon: Icons.mail_outline_rounded,
                label: 'Email',
                value: 'mehedi@squadup.gg',
                url: 'mailto:mehedi@squadup.gg',
              ),
              const SizedBox(height: 12),
              const _PremiumContactTile(
                icon: Icons.public_rounded,
                label: 'Website',
                value: 'squadup.gg',
                url: 'https://squadup.gg',
              ),
              const SizedBox(height: 32),
              Text(
                '${AppConstants.appName} v${AppConstants.appVersion}',
                style: PremiumTypography.caption.copyWith(
                  color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;
  
  const _PremiumContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListNavTile(
          icon: icon,
          label: label,
          subtitle: value,
          onTap: () => AppLinks.open(url),
        ),
      ),
    );
  }
}
