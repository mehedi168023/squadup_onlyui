import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/data/models/match_model.dart';
import '../../app/data/services/session_service.dart';
import '../../app/routes/app_routes.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/animations/premium_curves.dart';
import '../../design_system/animations/premium_durations.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../app/widgets/common_widgets.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../app/widgets/responsive.dart';
import 'widgets/match_card.dart';

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({super.key});

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  final GameMode mode = Get.arguments as GameMode;
  final session = SessionService.to;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          mode.title,
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
          child: Obx(() {
            final list = session.matchesForMode(mode.key);
            if (list.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                        child: _buildEmptyState(context, isDark),
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.fromLTRB(
                PremiumSpacing.screenHorizontal,
                PremiumSpacing.md,
                PremiumSpacing.screenHorizontal,
                MediaQuery.of(context).padding.bottom + 24,
              ),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 200 + (i * 50)),
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
                  child: PremiumMatchListCard(
                    match: list[i],
                    onTap: () => Get.toNamed(AppRoutes.matchInfo, arguments: list[i]),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: (isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.videogame_asset_outlined,
            size: 48,
            color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'No matches available right now',
          style: PremiumTypography.h5.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pull down to refresh',
          style: PremiumTypography.body.copyWith(
            color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
          ),
        ),
      ],
    );
  }
}

class PremiumMatchListCard extends StatelessWidget {
  final FfMatch match;
  final VoidCallback onTap;
  
  const PremiumMatchListCard({required this.match, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumCard(
      onTap: onTap,
      padding: PremiumSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  match.title,
                  style: PremiumTypography.h5.copyWith(
                    color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                    fontSize: 17,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              _buildStatusBadge(context, isDark),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  context,
                  isDark,
                  Icons.emoji_events_rounded,
                  PremiumColors.gold,
                  '${match.prize.toInt()} TK',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatChip(
                  context,
                  isDark,
                  Icons.my_location_rounded,
                  PremiumColors.killRed,
                  '${match.perKill.toInt()} TK',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatChip(
                  context,
                  isDark,
                  Icons.payments_rounded,
                  PremiumColors.primary,
                  '${match.entryFee.toInt()} TK',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MatchProgressBar(match: match),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isDark) {
    final bool isJoined = match.isJoined;
    final Color color = isJoined ? PremiumColors.success : PremiumColors.primary;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        isJoined ? 'Joined' : 'Active',
        style: PremiumTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    bool isDark,
    IconData icon,
    Color color,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3,
        borderRadius: BorderRadius.circular(PremiumRadius.md),
        border: Border.all(
          color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: PremiumTypography.labelSmall.copyWith(
              color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
