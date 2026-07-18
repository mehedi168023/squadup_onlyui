import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/data/services/session_service.dart';
import '../../app/routes/app_routes.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../app/widgets/premium_back_button.dart';
import '../matches/match_list_screen.dart';

class MyMatchesScreen extends StatefulWidget {
  const MyMatchesScreen({super.key});

  @override
  State<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> {
  final session = SessionService.to;

  @override
  void initState() {
    super.initState();
    session.fetchMyMatches();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'My Matches',
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      body: Obx(() {
        final joined = session.joinedMatches;
        if (joined.isEmpty) {
          return _buildEmptyState(context, isDark);
        }
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(
            PremiumSpacing.screenHorizontal,
            PremiumSpacing.md,
            PremiumSpacing.screenHorizontal,
            MediaQuery.of(context).padding.bottom + 24,
          ),
          itemCount: joined.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, i) {
            final m = joined[i];
            return Column(
              children: [
                PremiumMatchListCard(
                  match: m,
                  onTap: () => Get.toNamed(AppRoutes.matchInfo, arguments: m),
                ),
                if (m.roomId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildRoomInfoCard(context, isDark, m),
                  ),
              ],
            );
          },
        );
      }),
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
            child: Icon(
              Icons.sports_esports_outlined,
              size: 48,
              color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Join a match to see it here',
            style: PremiumTypography.h5.copyWith(
              color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your joined matches will appear here',
            style: PremiumTypography.body.copyWith(
              color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomInfoCard(BuildContext context, bool isDark, dynamic match) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      color: PremiumColors.primary.withOpacity(0.1),
      border: Border.all(
        color: PremiumColors.primary.withOpacity(0.3),
        width: 1,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PremiumColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.meeting_room_rounded,
              color: PremiumColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Room ID: ${match.roomId}  •  Pass: ${match.roomPassword}',
              style: PremiumTypography.labelSmall.copyWith(
                color: PremiumColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
