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
import '../../app/widgets/premium_back_button.dart';
import '../../app/widgets/responsive.dart';
import 'widgets/match_card.dart';

class JoinMatchController extends GetxController {
  final FfMatch match;
  JoinMatchController(this.match);

  final slotType = 0.obs;
  final loading = false.obs;
  final List<TextEditingController> fields =
      List.generate(2, (_) => TextEditingController());

  int get slotCount => slotType.value == 0 ? 1 : 2;

  @override
  void onInit() {
    super.onInit();
    slotType.value = match.type.toLowerCase() == 'duo' ? 1 : 0;
  }

  Future<void> join() async {
    final names = List.generate(slotCount, (i) => fields[i].text.trim());
    if (names.any((n) => n.isEmpty)) {
      AppToast.error('Enter all player in-game names');
      return;
    }
    loading.value = true;
    final ok = await SessionService.to.joinMatch(match, names);
    loading.value = false;
    if (ok) {
      Get.back();
      NotificationService.to.showHeadsUp(
        HeadsUpNotification(
          id: 'join_${match.id}',
          title: 'Registration Successful 🎮',
          message: 'You joined ${match.title}. Best of luck!',
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
      AppToast.error('Failed to join.');
    }
  }

  @override
  void onClose() {
    for (final f in fields) {
      f.dispose();
    }
    super.onClose();
  }
}

class JoinMatchScreen extends StatefulWidget {
  const JoinMatchScreen({super.key});

  @override
  State<JoinMatchScreen> createState() => _JoinMatchScreenState();
}

class _JoinMatchScreenState extends State<JoinMatchScreen> {
  late final FfMatch match = Get.arguments as FfMatch;
  late final JoinMatchController c = Get.put(JoinMatchController(match));

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
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? PremiumColors.darkSurface1 : PremiumColors.lightCard,
            border: Border(
              top: BorderSide(
                color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
              ),
            ),
          ),
          child: Obx(() => PremiumButton.primary(
                text: 'Join Match',
                icon: const Icon(Icons.add_circle_outline_rounded),
                onPressed: c.loading.value ? null : c.join,
                isLoading: c.loading.value,
                isFullWidth: true,
                customColor: PremiumColors.winning,
              )),
        ),
      ),
      body: ResponsiveCenter(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            PremiumSpacing.screenHorizontal,
            PremiumSpacing.md,
            PremiumSpacing.screenHorizontal,
            16,
          ),
          children: [
            MatchInfoCard(match: match, showSlots: true, compact: true),
            const SizedBox(height: 24),
            Text(
              'SELECT SLOT TYPE',
              style: PremiumTypography.labelLarge.copyWith(
                color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _buildSlotOption(context, isDark, c, 0, Icons.person_rounded, 'Solo', '1P'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSlotOption(context, isDark, c, 1, Icons.groups_rounded, 'Duo', '2P'),
                    ),
                  ],
                )),
            const SizedBox(height: 24),
            Obx(() => Row(
                  children: [
                    Text(
                      'PLAYER NAMES',
                      style: PremiumTypography.labelLarge.copyWith(
                        color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: PremiumColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${c.slotCount} slot(s)',
                        style: PremiumTypography.labelSmall.copyWith(
                          color: PremiumColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 16),
            Obx(() => Column(
                  children: List.generate(
                    c.slotCount,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPlayerField(context, isDark, c, i),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotOption(
    BuildContext context,
    bool isDark,
    JoinMatchController c,
    int index,
    IconData icon,
    String label,
    String tag,
  ) {
    final active = c.slotType.value == index;
    
    return GestureDetector(
      onTap: () => c.slotType.value = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: active
              ? PremiumColors.primary
              : (isDark ? PremiumColors.darkCard : PremiumColors.lightCard),
          borderRadius: BorderRadius.circular(PremiumRadius.md),
          border: Border.all(
            color: active
                ? PremiumColors.primary
                : (isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder),
            width: active ? 2 : 1,
          ),
          boxShadow: active ? PremiumShadows.primaryGlow : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: active
                  ? Colors.white
                  : (isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: PremiumTypography.bodyMedium.copyWith(
                color: active
                    ? Colors.white
                    : (isDark ? PremiumColors.darkText : PremiumColors.lightText),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: active ? Colors.black.withOpacity(0.25) : PremiumColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tag,
                style: PremiumTypography.labelSmall.copyWith(
                  color: active ? Colors.white : PremiumColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerField(
    BuildContext context,
    bool isDark,
    JoinMatchController c,
    int i,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkCard : PremiumColors.lightCard,
        borderRadius: BorderRadius.circular(PremiumRadius.md),
        border: Border.all(
          color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            alignment: Alignment.center,
            child: Text(
              '${i + 1}',
              style: PremiumTypography.h5.copyWith(
                color: PremiumColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: c.fields[i],
              textInputAction: i == c.slotCount - 1
                  ? TextInputAction.done
                  : TextInputAction.next,
              onSubmitted: i == c.slotCount - 1 ? (_) => c.join() : null,
              style: PremiumTypography.body.copyWith(
                color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
              ),
              decoration: InputDecoration(
                hintText: 'In-game name',
                hintStyle: PremiumTypography.body.copyWith(
                  color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
