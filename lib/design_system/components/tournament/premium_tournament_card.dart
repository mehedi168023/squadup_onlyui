import 'package:flutter/material.dart';
import '../../tokens/premium_colors.dart';
import '../../tokens/premium_typography.dart';
import '../../tokens/premium_spacing.dart';
import '../../tokens/premium_radius.dart';
import '../../animations/premium_animations.dart';

/// Premium tournament card with Samsung One UI-inspired design
/// Rich, interactive card with game info, prize pool, and countdown
class PremiumTournamentCard extends StatelessWidget {
  final String title;
  final String game;
  final String prizePool;
  final String entryFee;
  final int participants;
  final int maxParticipants;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isLive;
  final String? countdown;
  
  const PremiumTournamentCard({
    super.key,
    required this.title,
    required this.game,
    required this.prizePool,
    required this.entryFee,
    required this.participants,
    required this.maxParticipants,
    this.imageUrl,
    this.onTap,
    this.isLive = false,
    this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? PremiumColors.darkCard : PremiumColors.lightCard,
          borderRadius: BorderRadius.circular(PremiumRadius.card),
          boxShadow: context.shadowCard,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isDark),
            Padding(
              padding: PremiumSpacing.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context, isDark),
                  const SizedBox(height: 12),
                  _buildGameBadge(context, isDark),
                  const SizedBox(height: 16),
                  _buildStats(context, isDark),
                  const SizedBox(height: 12),
                  _buildProgressBar(context, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PremiumColors.primary.withOpacity(0.8),
            PremiumColors.primaryDark,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(PremiumRadius.card),
          topRight: Radius.circular(PremiumRadius.card),
        ),
      ),
      child: Stack(
        children: [
          if (imageUrl != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(PremiumRadius.card),
                  topRight: Radius.circular(PremiumRadius.card),
                ),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),
            ),
          Positioned(
            top: 12,
            right: 12,
            child: _buildLiveBadge(),
          ),
          if (countdown != null)
            Positioned(
              bottom: 12,
              left: 12,
              child: _buildCountdownBadge(isDark),
            ),
        ],
      ),
    );
  }
  
  Widget _buildLiveBadge() {
    if (!isLive) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: PremiumColors.liveRed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'LIVE',
            style: PremiumTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCountdownBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time_rounded,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            countdown!,
            style: PremiumTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTitle(BuildContext context, bool isDark) {
    return Text(
      title,
      style: PremiumTypography.h5.copyWith(
        color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  Widget _buildGameBadge(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        game.toUpperCase(),
        style: PremiumTypography.labelSmall.copyWith(
          color: PremiumColors.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
  
  Widget _buildStats(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            isDark,
            icon: Icons.emoji_events_rounded,
            label: 'Prize Pool',
            value: prizePool,
            color: PremiumColors.gold,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            context,
            isDark,
            icon: Icons.account_balance_wallet_rounded,
            label: 'Entry Fee',
            value: entryFee,
            color: PremiumColors.primary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatItem(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: PremiumTypography.captionSmall.copyWith(
                color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: PremiumTypography.bodyMedium.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildProgressBar(BuildContext context, bool isDark) {
    final double progress = participants / maxParticipants;
    final bool isAlmostFull = progress >= 0.8;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.people_rounded,
                  size: 16,
                  color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '$participants/$maxParticipants Players',
                  style: PremiumTypography.caption.copyWith(
                    color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            if (isAlmostFull)
              Text(
                'Almost Full!',
                style: PremiumTypography.captionSmall.copyWith(
                  color: PremiumColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightBorderSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(
              isAlmostFull ? PremiumColors.warning : PremiumColors.primary,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
