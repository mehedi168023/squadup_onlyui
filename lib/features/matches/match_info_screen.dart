import 'dart:async';
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
import '../../design_system/tokens/premium_shadows.dart';
import '../../app/widgets/responsive.dart';

class MatchInfoController extends GetxController {
  final FfMatch match;
  MatchInfoController(this.match);

  final tab = 0.obs;
  final rulesExpanded = false.obs;
  final remaining = Duration.zero.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final diff = match.startTime.difference(DateTime.now());
    remaining.value = diff.isNegative ? Duration.zero : diff;
  }

  String get countdownLabel {
    final d = remaining.value;
    if (d == Duration.zero) return 'Started';
    final h = d.inHours, m = d.inMinutes % 60, s = d.inSeconds % 60;
    if (h > 0) return '${h}h ${m}m ${s}s';
    return '${m}m ${s}s';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class MatchInfoScreen extends StatefulWidget {
  const MatchInfoScreen({super.key});

  @override
  State<MatchInfoScreen> createState() => _MatchInfoScreenState();
}

class _MatchInfoScreenState extends State<MatchInfoScreen> {
  late final FfMatch match = Get.arguments as FfMatch;
  late final MatchInfoController c = Get.put(MatchInfoController(match));

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        centerTitle: true,
        title: Text(
          match.title,
          overflow: TextOverflow.ellipsis,
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      bottomNavigationBar: _PremiumBottomBar(controller: c),
      body: ResponsiveCenter(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            PremiumSpacing.screenHorizontal,
            PremiumSpacing.sm,
            PremiumSpacing.screenHorizontal,
            16,
          ),
          children: [
            _PremiumHeaderCard(controller: c),
            const SizedBox(height: 20),
            _PremiumSegmentedTabs(controller: c),
            const SizedBox(height: 20),
            Obx(() => c.tab.value == 0
                ? _PremiumRulesContent(controller: c)
                : _PremiumParticipantsContent(match: match)),
          ],
        ),
      ),
    );
  }
}

class _PremiumHeaderCard extends StatelessWidget {
  final MatchInfoController controller;
  const _PremiumHeaderCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final match = controller.match;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumCard(
      padding: PremiumSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildPill(match.modeLabel, PremiumColors.primary),
              const Spacer(),
              Obx(() => _buildPill(
                    controller.countdownLabel,
                    PremiumColors.winning,
                    icon: Icons.schedule_rounded,
                  )),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMoneyStat(
                  context,
                  Icons.emoji_events_rounded,
                  PremiumColors.gold,
                  'PRIZE',
                  match.prize,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMoneyStat(
                  context,
                  Icons.my_location_rounded,
                  PremiumColors.killRed,
                  'PER KILL',
                  match.perKill,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMoneyStat(
                  context,
                  Icons.confirmation_num_rounded,
                  PremiumColors.winning,
                  'ENTRY',
                  match.entryFee,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Slots filled',
                style: PremiumTypography.caption.copyWith(
                  color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '${match.slotsTaken}/${match.slotsTotal}',
                style: PremiumTypography.bodyMedium.copyWith(
                  color: PremiumColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(PremiumRadius.full),
            child: LinearProgressIndicator(
              value: match.slotProgress,
              minHeight: 8,
              backgroundColor: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightBorderSubtle,
              valueColor: const AlwaysStoppedAnimation(PremiumColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: PremiumTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyStat(
    BuildContext context,
    IconData icon,
    Color color,
    String label,
    double value,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3,
        borderRadius: BorderRadius.circular(PremiumRadius.md),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            taka(value),
            style: PremiumTypography.label.copyWith(
              color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
              fontWeight: FontWeight.w700,
            ),
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
    );
  }
}

class _PremiumSegmentedTabs extends StatelessWidget {
  final MatchInfoController controller;
  const _PremiumSegmentedTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3,
        borderRadius: BorderRadius.circular(PremiumRadius.md),
      ),
      child: Obx(() {
        final sel = controller.tab.value;
        return LayoutBuilder(builder: (context, constraints) {
          final segW = constraints.maxWidth / 2;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: sel * segW,
                top: 0,
                bottom: 0,
                width: segW,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? PremiumColors.darkCard : PremiumColors.lightCard,
                    borderRadius: BorderRadius.circular(PremiumRadius.sm),
                    boxShadow: isDark ? PremiumShadows.darkCard : PremiumShadows.lightCard,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.tab.value = 0,
                      child: Center(
                        child: Text(
                          'Rules',
                          style: PremiumTypography.label.copyWith(
                            color: sel == 0
                                ? (isDark ? PremiumColors.darkText : PremiumColors.lightText)
                                : (isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary),
                            fontWeight: sel == 0 ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.tab.value = 1,
                      child: Center(
                        child: Text(
                          'Participants',
                          style: PremiumTypography.label.copyWith(
                            color: sel == 1
                                ? (isDark ? PremiumColors.darkText : PremiumColors.lightText)
                                : (isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary),
                            fontWeight: sel == 1 ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      }),
    );
  }
}

class _PremiumRulesContent extends StatelessWidget {
  final MatchInfoController controller;
  const _PremiumRulesContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final match = controller.match;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MATCH DETAILS',
          style: PremiumTypography.labelLarge.copyWith(
            color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        _PremiumIosGroup(rows: [
          _PremiumDetailRow(label: 'Match ID', value: '#${match.id}'),
          _PremiumDetailRow(label: 'Mode', value: match.modeLabel),
          _PremiumDetailRow(label: 'Map', value: match.mapName),
          _PremiumDetailRow(
            label: 'Start Time',
            value: fullDateWeekday(match.startTime),
            valueIsTitle: true,
          ),
        ]),
        const SizedBox(height: 24),
        Text(
          'RULES',
          style: PremiumTypography.labelLarge.copyWith(
            color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          padding: PremiumSpacing.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final rule in match.rules)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: PremiumColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          rule,
                          style: PremiumTypography.body.copyWith(
                            color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PremiumParticipantsContent extends StatelessWidget {
  final FfMatch match;
  const _PremiumParticipantsContent({required this.match});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PARTICIPANTS (${match.slotsTaken}/${match.slotsTotal})',
          style: PremiumTypography.labelLarge.copyWith(
            color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        if (match.participants.isEmpty)
          PremiumCard(
            padding: PremiumSpacing.card,
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    size: 48,
                    color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No participants yet',
                    style: PremiumTypography.body.copyWith(
                      color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: match.participants.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              return _PremiumSlotBadge(
                slot: i + 1,
                name: p.name,
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _PremiumIosGroup extends StatelessWidget {
  final List<_PremiumDetailRow> rows;
  const _PremiumIosGroup({required this.rows});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
              ),
          ],
        ],
      ),
    );
  }
}

class _PremiumDetailRow extends StatelessWidget {
  final String? label;
  final String value;
  final bool valueIsTitle;
  
  const _PremiumDetailRow({
    this.label,
    required this.value,
    this.valueIsTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          if (label != null)
            Text(
              label!,
              style: PremiumTypography.body.copyWith(
                color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
              ),
            ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: valueIsTitle
                  ? PremiumTypography.bodyMedium.copyWith(
                      color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                    )
                  : PremiumTypography.label.copyWith(
                      color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumSlotBadge extends StatelessWidget {
  final int slot;
  final String name;
  
  const _PremiumSlotBadge({
    required this.slot,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: PremiumColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: PremiumColors.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PremiumColors.primary.withOpacity(0.2),
            ),
            child: Text(
              '$slot',
              style: PremiumTypography.labelSmall.copyWith(
                color: PremiumColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: PremiumTypography.labelSmall.copyWith(
              color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumBottomBar extends StatelessWidget {
  final MatchInfoController controller;
  const _PremiumBottomBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final session = SessionService.to;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? PremiumColors.darkSurface1 : PremiumColors.lightCard,
          border: Border(
            top: BorderSide(
              color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
              width: 1,
            ),
          ),
        ),
        child: Obx(() {
          final live = session.matches.firstWhere(
            (m) => m.id == controller.match.id,
            orElse: () => controller.match,
          );
          final joined = live.isJoined;
          
          return PremiumButton.primary(
            text: joined ? 'Already Joined' : 'Join Match',
            icon: Icon(
              joined ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
            ),
            onPressed: joined
                ? null
                : () => Get.toNamed(AppRoutes.joinMatch, arguments: live),
            isFullWidth: true,
            customColor: PremiumColors.winning,
          );
        }),
      ),
    );
  }
}
