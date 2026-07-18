import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/data/mock/mock_data.dart';
import '../../app/data/services/session_service.dart';
import '../../app/routes/app_routes.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../app/widgets/responsive.dart';
import 'game_mode_card.dart';

class FreeFireScreen extends StatelessWidget {
  const FreeFireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionService.to;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'Free Fire',
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: PremiumColors.primary,
        backgroundColor: isDark ? PremiumColors.darkCardElevated : PremiumColors.lightCard,
        onRefresh: session.refreshMatches,
        child: ResponsiveCenter(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              PremiumSpacing.screenHorizontal,
              PremiumSpacing.md,
              PremiumSpacing.screenHorizontal,
              MediaQuery.of(context).padding.bottom + 24,
            ),
            children: [
              Text(
                'ALL GAMES & MODES',
                style: PremiumTypography.labelLarge.copyWith(
                  color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: MockData.gameModes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (_, i) {
                  final mode = MockData.gameModes[i];
                  return GameModeCard(
                    mode: mode,
                    matchesFound: mode.matchesFound,
                    onTap: () => Get.toNamed(AppRoutes.matchList, arguments: mode),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
