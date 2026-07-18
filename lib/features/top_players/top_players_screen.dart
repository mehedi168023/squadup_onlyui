import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/data/mock/mock_data.dart';
import '../../app/data/models/misc_models.dart';
import '../../app/data/services/session_service.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../design_system/tokens/premium_shadows.dart';
import '../../app/widgets/responsive.dart';

class TopPlayersScreen extends StatefulWidget {
  const TopPlayersScreen({super.key});

  @override
  State<TopPlayersScreen> createState() => _TopPlayersScreenState();
}

class _TopPlayersScreenState extends State<TopPlayersScreen> {
  final session = SessionService.to;

  @override
  void initState() {
    super.initState();
    session.fetchLeaderboard();
  }

  Color _rankColor(int rank) => switch (rank) {
        1 => PremiumColors.gold,
        2 => PremiumColors.silver,
        3 => PremiumColors.bronze,
        _ => PremiumColors.darkTextSecondary,
      };

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'Top Players',
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      body: ResponsiveCenter(
        child: Obx(() {
          final board = session.leaderboard.isNotEmpty
              ? session.leaderboard.toList()
              : MockData.leaderboard;
          final top3 = board.take(3).toList();
          final user = session.user.value;
          final rank = session.yourRank.value ?? MockData.yourRank;
          final earnings = session.wallet.value.wonAmount;

          return ListView(
            padding: EdgeInsets.fromLTRB(
              PremiumSpacing.screenHorizontal,
              PremiumSpacing.md,
              PremiumSpacing.screenHorizontal,
              MediaQuery.of(context).padding.bottom + 24,
            ),
            children: [
              _buildYourPositionCard(context, isDark, rank, user?.name, earnings),
              const SizedBox(height: 20),
              if (top3.length == 3) _PremiumPodium(top3: top3, rankColor: _rankColor),
              const SizedBox(height: 24),
              Text(
                'ALL PLAYERS',
                style: PremiumTypography.labelLarge.copyWith(
                  color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ...board.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PremiumRankRow(entry: e, color: _rankColor(e.rank)),
                  )),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildYourPositionCard(
    BuildContext context,
    bool isDark,
    int rank,
    String? name,
    double earnings,
  ) {
    return Container(
      padding: PremiumSpacing.card,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PremiumColors.primary.withOpacity(0.2),
            (isDark ? PremiumColors.darkCard : PremiumColors.lightCard).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(PremiumRadius.card),
        border: Border.all(
          color: PremiumColors.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: PremiumColors.primary,
              shape: BoxShape.circle,
              boxShadow: PremiumShadows.primaryGlow,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: PremiumTypography.h5.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Position',
                  style: PremiumTypography.caption.copyWith(
                    color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name ?? 'Guest',
                  style: PremiumTypography.h5.copyWith(
                    color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total Earnings',
                style: PremiumTypography.caption.copyWith(
                  color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                taka(earnings),
                style: PremiumTypography.h5.copyWith(
                  color: PremiumColors.gold,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PremiumPodium extends StatelessWidget {
  final List<LeaderboardEntry> top3;
  final Color Function(int) rankColor;
  
  const _PremiumPodium({required this.top3, required this.rankColor});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumCard(
      padding: PremiumSpacing.card,
      child: Column(
        children: [
          Center(
            child: Text(
              'TOP PLAYERS',
              style: PremiumTypography.labelLarge.copyWith(
                color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: _buildPodiumColumn(top3[1], 90, rankColor(2), false)),
              Expanded(child: _buildPodiumColumn(top3[0], 120, rankColor(1), true)),
              Expanded(child: _buildPodiumColumn(top3[2], 70, rankColor(3), false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn(LeaderboardEntry e, double height, Color color, bool crown) {
    return Column(
      children: [
        Icon(
          crown ? Icons.workspace_premium_rounded : Icons.emoji_events_rounded,
          color: color,
          size: crown ? 36 : 28,
        ),
        const SizedBox(height: 8),
        Text(
          e.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: PremiumTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          taka(e.wonAmount),
          style: PremiumTypography.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: color.withOpacity(0.5), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            '#${e.rank}',
            style: PremiumTypography.h2.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _PremiumRankRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final Color color;
  
  const _PremiumRankRow({required this.entry, required this.color});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isTop3 = entry.rank <= 3;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkCard : PremiumColors.lightCard,
        borderRadius: BorderRadius.circular(PremiumRadius.md),
        border: Border.all(
          color: isTop3 ? color.withOpacity(0.5) : (isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder),
          width: isTop3 ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '#${entry.rank}',
              style: PremiumTypography.bodyMedium.copyWith(
                color: isTop3 ? color : (isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              entry.name,
              style: PremiumTypography.bodyMedium.copyWith(
                color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(Icons.emoji_events_rounded, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            taka(entry.wonAmount),
            style: PremiumTypography.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
