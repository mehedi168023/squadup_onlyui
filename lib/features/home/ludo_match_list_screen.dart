import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/data/models/match_model.dart';
import '../../app/data/services/session_service.dart';
import '../../app/routes/app_routes.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../design_system/components/buttons/premium_button.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../app/widgets/responsive.dart';

enum _LudoFilter { all, mine, lowHigh, highLow }

class LudoMatchListScreen extends StatefulWidget {
  const LudoMatchListScreen({super.key});

  @override
  State<LudoMatchListScreen> createState() => _LudoMatchListScreenState();
}

class _LudoMatchListScreenState extends State<LudoMatchListScreen> {
  final GameMode mode = Get.arguments as GameMode;
  final session = SessionService.to;
  _LudoFilter filter = _LudoFilter.all;

  List<FfMatch> _apply(List<FfMatch> source) {
    final list = [...source];
    switch (filter) {
      case _LudoFilter.mine:
        return list.where((m) => m.isJoined).toList();
      case _LudoFilter.lowHigh:
        list.sort((a, b) => a.entryFee.compareTo(b.entryFee));
      case _LudoFilter.highLow:
        list.sort((a, b) => b.entryFee.compareTo(a.entryFee));
      case _LudoFilter.all:
        break;
    }
    return list;
  }

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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: _PremiumWinSsButton(),
          ),
        ],
      ),
      body: ResponsiveCenter(
        child: Column(
          children: [
            _PremiumFilterBar(current: filter, onSelect: (f) => setState(() => filter = f)),
            Expanded(
              child: Obx(() {
                final list = _apply(session.matchesForMode(mode.key));
                if (list.isEmpty) {
                  return _buildEmptyState(context, isDark);
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
                  itemBuilder: (_, i) => RepaintBoundary(
                    child: _PremiumLudoMatchCard(match: list[i]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.casino_outlined, size: 48,
                color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary),
          ),
          const SizedBox(height: 20),
          Text('No matches here',
              style: PremiumTypography.h5.copyWith(color: isDark ? PremiumColors.darkText : PremiumColors.lightText)),
          const SizedBox(height: 8),
          Text('Try another filter or pull to refresh',
              style: PremiumTypography.body.copyWith(color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary)),
        ],
      ),
    );
  }
}

class _PremiumWinSsButton extends StatelessWidget {
  const _PremiumWinSsButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.uploadEvidence),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: PremiumColors.winning.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: PremiumColors.winning.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_upload_outlined, size: 16, color: PremiumColors.winning),
            const SizedBox(width: 6),
            Text('Win SS',
                style: PremiumTypography.labelSmall.copyWith(
                    color: PremiumColors.winning, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _PremiumFilterBar extends StatelessWidget {
  final _LudoFilter current;
  final ValueChanged<_LudoFilter> onSelect;
  const _PremiumFilterBar({required this.current, required this.onSelect});

  static const _items = [
    (_LudoFilter.all, Icons.sports_esports_rounded, 'All Matches'),
    (_LudoFilter.mine, Icons.person_rounded, 'My Match'),
    (_LudoFilter.lowHigh, Icons.trending_up_rounded, 'Low to High'),
    (_LudoFilter.highLow, Icons.trending_down_rounded, 'High to Low'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final item = _items[i];
          final active = current == item.$1;
          return GestureDetector(
            onTap: () => onSelect(item.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? PremiumColors.winning.withOpacity(0.15) : context.card,
                borderRadius: BorderRadius.circular(PremiumRadius.md),
                border: Border.all(
                  color: active ? PremiumColors.winning : context.border,
                  width: active ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(item.$2, size: 18, color: active ? PremiumColors.winning : context.textTertiary),
                  const SizedBox(width: 8),
                  Text(item.$3,
                      style: PremiumTypography.labelSmall.copyWith(
                        color: active ? PremiumColors.winning : context.textSecondary,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PremiumLudoMatchCard extends StatelessWidget {
  final FfMatch match;
  const _PremiumLudoMatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool joined = match.isJoined;

    return PremiumCard(
      padding: PremiumSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  gradient: PremiumColors.primaryGradient,
                  borderRadius: BorderRadius.circular(PremiumRadius.md),
                  boxShadow: PremiumShadows.primaryGlow,
                ),
                child: const Icon(Icons.casino_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${match.title} MATCH ${match.code}',
                        style: PremiumTypography.bodyMedium.copyWith(
                            color: isDark ? PremiumColors.darkText : PremiumColors.lightText)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.emoji_events_rounded, color: PremiumColors.gold, size: 14),
                        const SizedBox(width: 4),
                        Text('${match.slotsTaken}/${match.slotsTotal} Players',
                            style: PremiumTypography.captionSmall.copyWith(
                                color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStat('ENTRY FEE', taka(match.entryFee), PremiumColors.gold)),
              const SizedBox(width: 8),
              Expanded(child: _buildStat('WIN PRIZE', taka(match.prize), PremiumColors.winning)),
              const SizedBox(width: 8),
              Expanded(child: _buildStat('PLAYERS', '${match.slotsTaken}/${match.slotsTotal}', PremiumColors.winning)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PremiumButton.primary(
              text: joined ? 'JOINED' : 'JOIN',
              onPressed: joined ? null : () => Get.toNamed(AppRoutes.ludoJoin, arguments: match),
              isFullWidth: true,
              size: PremiumButtonSize.small,
              customColor: PremiumColors.winning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: PremiumTypography.captionSmall.copyWith(fontSize: 9)),
        const SizedBox(height: 4),
        Text(value, style: PremiumTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
