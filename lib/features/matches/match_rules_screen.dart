import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/data/mock/mock_data.dart';
import '../../app/data/models/match_model.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../app/widgets/premium_back_button.dart';

class MatchRulesController extends GetxController {
  final selected = 0.obs;
}

class _ModeStyle {
  final IconData icon;
  final Color color;
  final String subtitle;
  const _ModeStyle(this.icon, this.color, this.subtitle);
}

_ModeStyle _styleFor(String key) {
  switch (key) {
    case 'br':
      return const _ModeStyle(Icons.public_rounded, PremiumColors.primary, 'Battle Royale · Solo & Squad');
    case 'cs':
      return const _ModeStyle(Icons.shield_moon_rounded, PremiumColors.winning, 'Clash Squad · 4 v 4');
    case 'lone_wolf':
      return const _ModeStyle(Icons.gps_fixed_rounded, PremiumColors.gold, 'Sniper Only · 1 v 1 / 2 v 2');
    case 'free':
      return const _ModeStyle(Icons.card_giftcard_rounded, PremiumColors.success, 'Free Entry · Practice Match');
    default:
      return const _ModeStyle(Icons.sports_esports_rounded, PremiumColors.primary, 'Tournament Rules');
  }
}

class _ParsedRules {
  final List<String> items;
  final List<String> notes;
  const _ParsedRules(this.items, this.notes);
}

_ParsedRules _parseRules(String raw) {
  final lines = raw.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
  final numbered = RegExp(r'^[০-৯0-9]+[.৷।)]\s*');
  final items = <String>[];
  final notes = <String>[];
  var headerSeen = false;
  for (final line in lines) {
    if (numbered.hasMatch(line)) {
      items.add(line.replaceFirst(numbered, '').trim());
    } else if (!headerSeen) {
      headerSeen = true;
    } else {
      notes.add(line);
    }
  }
  return _ParsedRules(items, notes);
}

class MatchRulesScreen extends StatelessWidget {
  const MatchRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MatchRulesController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const modes = MockData.gameModes;

    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text('Match Rules', style: PremiumTypography.h3.copyWith(
          color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
        )),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text('SELECT A MODE',
              style: PremiumTypography.labelLarge.copyWith(
                color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                fontWeight: FontWeight.w800, letterSpacing: 1.2,
              )),
          ),
          SizedBox(
            height: 50,
            child: Obx(() {
              final selected = c.selected.value;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: modes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => _buildChip(context, modes[i], selected == i, () => c.selected.value = i),
              );
            }),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final mode = modes[c.selected.value];
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween(begin: const Offset(0, 0.03), end: Offset.zero).animate(anim),
                    child: child,
                  ),
                ),
                child: _buildContent(context, mode),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, GameMode mode, bool active, VoidCallback onTap) {
    final st = _styleFor(mode.key);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: active ? LinearGradient(colors: [st.color, st.color.withOpacity(0.72)]) : null,
          color: active ? null : (isDark ? PremiumColors.darkCard : PremiumColors.lightCard),
          borderRadius: BorderRadius.circular(PremiumRadius.md),
          border: Border.all(color: active ? Colors.transparent : context.border),
          boxShadow: active ? [BoxShadow(color: st.color.withOpacity(0.35), blurRadius: 12)] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(st.icon, size: 18, color: active ? Colors.white : st.color),
            const SizedBox(width: 8),
            Text(mode.title, style: PremiumTypography.labelSmall.copyWith(
              color: active ? Colors.white : context.textSecondary,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, GameMode mode) {
    final st = _styleFor(mode.key);
    final parsed = _parseRules(MockData.rulesForMode(mode.key));
    return SingleChildScrollView(
      key: ValueKey(mode.key),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHero(context, mode, st),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.verified_rounded, size: 16, color: st.color),
              const SizedBox(width: 8),
              Text('RULES & GUIDELINES', style: PremiumTypography.labelLarge.copyWith(
                color: context.textSecondary, fontWeight: FontWeight.w800, letterSpacing: 1)),

              const Spacer(),
              Text('${parsed.items.length} points', style: PremiumTypography.labelSmall.copyWith(color: context.textTertiary)),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(parsed.items.length, (i) => _buildRuleItem(context, i + 1, parsed.items[i], st.color)),
          for (final note in parsed.notes) ...[
            const SizedBox(height: 8),
            _buildNote(context, note, st.color),
          ],
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, GameMode mode, _ModeStyle st) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final matches = mode.matchesFound;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [st.color.withOpacity(0.92), st.color.withOpacity(0.5)],
        ),
        borderRadius: BorderRadius.circular(PremiumRadius.card),
        boxShadow: [BoxShadow(color: st.color.withOpacity(0.32), blurRadius: 20)],
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(PremiumRadius.md),
              border: Border.all(color: Colors.white.withOpacity(0.35)),
            ),
            child: Icon(st.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mode.title, style: PremiumTypography.h3.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text(st.subtitle, style: PremiumTypography.body.copyWith(color: Colors.white.withOpacity(0.9))),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        matches == 1 ? '1 live match' : '$matches live matches',
                        style: PremiumTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(BuildContext context, int index, String text, Color accent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(PremiumRadius.md),
        border: Border.all(color: context.border),
        boxShadow: PremiumShadows.primaryGlow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30, height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [accent, accent.withOpacity(0.62)]),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: accent.withOpacity(0.3), blurRadius: 8)],
            ),
            child: Text('$index', style: PremiumTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text, style: PremiumTypography.body.copyWith(height: 1.6, color: context.text)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(BuildContext context, String text, Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(PremiumRadius.md),
        border: Border.all(color: accent.withOpacity(0.3)),
      ),
      child: Text(text,
        textAlign: TextAlign.center,
        style: PremiumTypography.body.copyWith(color: context.text, height: 1.5),
      ),
    );
  }
}
