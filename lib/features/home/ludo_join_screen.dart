import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_toast.dart';
import '../../app/data/models/heads_up_notification.dart';
import '../../app/data/models/match_model.dart';
import '../../app/data/services/notification_service.dart';
import '../../app/data/services/session_service.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../design_system/components/buttons/premium_button.dart';
import '../../design_system/components/inputs/premium_text_field.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../app/widgets/responsive.dart';

class LudoJoinScreen extends StatefulWidget {
  const LudoJoinScreen({super.key});

  @override
  State<LudoJoinScreen> createState() => _LudoJoinScreenState();
}

class _LudoJoinScreenState extends State<LudoJoinScreen> {
  final FfMatch match = Get.arguments as FfMatch;
  late final TextEditingController _name =
      TextEditingController(text: SessionService.to.user.value?.name ?? '');
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    if (_name.text.trim().isEmpty) {
      AppToast.warning('আপনার গেম নাম দিন');
      return;
    }
    setState(() => _loading = true);
    final ok = await SessionService.to.joinMatch(match, [_name.text.trim()]);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      Get.back();
      NotificationService.to.showHeadsUp(
        HeadsUpNotification(
          id: 'ludojoin_${match.id}',
          title: 'জয়েন সফল হয়েছে! 🎲',
          message: '${match.title} ম্যাচে আপনি যুক্ত হয়েছেন।',
          kind: NotifKind.action,
          priority: NotifPriority.high,
          icon: 'match',
          actionText: 'View My Matches',
          actionTarget: 'my_matches',
          sound: 'success',
        ),
        osNotify: true,
      );
    } else {
      AppToast.error('জয়েন ব্যর্থ হয়েছে।');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'Join Match',
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
            24,
          ),
          children: [
            PremiumCard(
              padding: PremiumSpacing.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'SPECIAL MATCH ${match.code}',
                          style: PremiumTypography.h4.copyWith(
                            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: PremiumColors.winning.withOpacity(0.5)),
                        ),
                        child: Text(
                          'MATCH',
                          style: PremiumTypography.labelSmall.copyWith(
                            color: PremiumColors.winning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: PremiumColors.winning),
                      const SizedBox(width: 8),
                      Text(
                        fullDateWeekday(match.startTime),
                        style: PremiumTypography.caption.copyWith(
                          color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildPrizeCard(
                    context,
                    isDark,
                    'এন্ট্রি ফি',
                    taka(match.entryFee),
                    Icons.confirmation_num_rounded,
                    PremiumColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPrizeCard(
                    context,
                    isDark,
                    'জয়ের পুরস্কার',
                    taka(match.prize),
                    Icons.emoji_events_rounded,
                    PremiumColors.winning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PremiumCard(
              padding: PremiumSpacing.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline_rounded, color: PremiumColors.winning, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'আপনার গেম নাম',
                        style: PremiumTypography.h6.copyWith(
                          color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PremiumTextField(
                    controller: _name,
                    hint: 'আপনার গেম নাম লিখুন',
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _join(),
                  ),
                  const SizedBox(height: 20),
                  PremiumButton.primary(
                    text: 'জয়েন করুন',
                    onPressed: _loading ? null : _join,
                    isLoading: _loading,
                    isFullWidth: true,
                    customColor: PremiumColors.winning,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'জয়েন করলে এন্ট্রি ফি আপনার ব্যালেন্স/উইন থেকে কাটা হবে।',
                    style: PremiumTypography.caption.copyWith(
                      color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrizeCard(
    BuildContext context,
    bool isDark,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: PremiumTypography.caption.copyWith(
                    color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: PremiumTypography.h4.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(PremiumRadius.md),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
        ],
      ),
    );
  }
}
