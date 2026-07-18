import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/core/app_loader.dart';
import '../../app/core/app_sheets.dart';
import '../../app/core/app_toast.dart';
import '../../app/data/models/misc_models.dart';
import '../../app/data/services/session_service.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../design_system/components/buttons/premium_button.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../app/widgets/responsive.dart';

class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});

  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  final TopupCategory cat = Get.arguments as TopupCategory;
  final _userId = TextEditingController();
  int _pack = -1;
  int _payment = 0;

  static const _payments = [
    ('SquadUp', 'Fast • Secure • Reliable', true),
    ('Direct Gateway', 'Secure • Instant • Easy', false),
  ];

  @override
  void dispose() {
    _userId.dispose();
    super.dispose();
  }

  Future<void> _buy() async {
    if (_userId.text.trim().isEmpty) { AppToast.warning('Enter your ${cat.idLabel} first'); return; }
    if (_pack < 0) { AppToast.warning('Select a pack'); return; }
    final p = cat.packs[_pack];
    final method = _payment == 0 ? 'wallet' : 'gateway';
    AppLoader.show();
    final ok = await SessionService.to.submitTopupOrder(
      categoryKey: cat.key, packId: _pack,
      gameUserId: _userId.text.trim(), price: p.price,
      amount: p.amount, unit: p.unit, paymentMethod: method,
    );
    AppLoader.dismiss();
    if (!ok || !mounted) return;
    AppToast.success('Order #${SessionService.to.orders.first.id} placed: ${p.amount} ${p.unit} via ${_payments[_payment].$1}');
  }

  void _openHowTo() {
    AppSheet.show(
      title: 'Help & Guide',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final s in cat.howTo) ...[
            Text(s.title, style: PremiumTypography.h5.copyWith(color: PremiumColors.primary)),
            const SizedBox(height: 8),
            ...s.steps.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('${e.key + 1}. ${e.value}', style: PremiumTypography.body.copyWith(height: 1.5)),
            )),
            const SizedBox(height: 16),
          ],
          if (cat.guideImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(PremiumRadius.md),
              child: Image.asset(cat.guideImage!, width: double.infinity, fit: BoxFit.contain, cacheWidth: 900),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(cat.title, style: PremiumTypography.h3.copyWith(
          color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
        )),
      ),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            _buildStepCard(context, isDark, '01', 'ENTER', 'GAME UID', 'Enter your ${cat.idLabel} to top-up', [
              _buildUidField(context, isDark),
            ]),
            const SizedBox(height: 20),
            _buildStepCard(context, isDark, '02', 'SELECT', 'PACK', 'Choose the best pack for you', cat.packs.asMap().entries.map((e) => _buildPackTile(e.key, e.value, isDark)).toList()),
            const SizedBox(height: 20),
            _buildStepCard(context, isDark, '03', 'PAYMENT', 'METHOD', 'Choose how to pay', _buildPaymentOptions(isDark)),
            const SizedBox(height: 24),
            ..._buildBuyButton(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, bool isDark, String step, String lead, String accent, String subtitle, List<Widget> children) {
    return PremiumCard(
      padding: PremiumSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28, height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: PremiumColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(step, style: PremiumTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 8),
              Text(lead, style: PremiumTypography.h6.copyWith(color: context.textSecondary)),
              Text(accent, style: PremiumTypography.h6.copyWith(color: PremiumColors.primary, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: PremiumTypography.caption.copyWith(color: context.textTertiary)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
  Widget _buildUidField(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? PremiumColors.darkCard : PremiumColors.lightCard,
            borderRadius: BorderRadius.circular(PremiumRadius.input),
            border: Border.all(color: context.border),
          ),
          child: TextField(
            controller: _userId,
            textInputAction: TextInputAction.done,
            style: PremiumTypography.body.copyWith(color: context.text),
            decoration: InputDecoration(
              hintText: 'Enter your ${cat.idLabel}',
              hintStyle: PremiumTypography.body.copyWith(color: context.textTertiary),
              prefixIcon: const Padding(padding: EdgeInsets.only(left: 16), child: Icon(Icons.badge_outlined)),
              border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _openHowTo,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 16, color: PremiumColors.primary),
              const SizedBox(width: 6),
              Text('How to find UID?', style: PremiumTypography.labelSmall.copyWith(color: PremiumColors.primary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPackTile(int index, TopupPack pack, bool isDark) {
    final active = _pack == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => setState(() => _pack = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: active ? PremiumColors.winning.withOpacity(0.1) : (isDark ? PremiumColors.darkSurface2 : PremiumColors.lightSurface2),
            borderRadius: BorderRadius.circular(PremiumRadius.md),
            border: Border.all(color: active ? PremiumColors.winning : context.border, width: active ? 2 : 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pack.title, style: PremiumTypography.bodyMedium.copyWith(color: context.text)),
                    const SizedBox(height: 4),
                    Text('${pack.amount} ${pack.unit}', style: PremiumTypography.h6.copyWith(color: PremiumColors.primary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: active ? PremiumColors.primaryGradient : (isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(taka(pack.price), style: PremiumTypography.labelSmall.copyWith(
                  color: active ? Colors.white : context.textSecondary, fontWeight: FontWeight.w700)),
              ),
              if (active) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check_circle_rounded, color: PremiumColors.winning, size: 22),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPaymentOptions(bool isDark) {
    return List.generate(_payments.length, (i) {
      final active = _payment == i;
      final p = _payments[i];
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () => setState(() => _payment = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: active ? PremiumColors.primary.withOpacity(0.1) : (isDark ? PremiumColors.darkSurface2 : PremiumColors.lightSurface2),
              borderRadius: BorderRadius.circular(PremiumRadius.md),
              border: Border.all(color: active ? PremiumColors.primary : context.border, width: active ? 2 : 1),
            ),
            child: Row(
              children: [
                Radio<int>(
                  value: i,
                  groupValue: _payment,
                  onChanged: (v) => setState(() => _payment = v!),
                  activeColor: PremiumColors.primary,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.$1, style: PremiumTypography.bodyMedium.copyWith(color: context.text)),
                      const SizedBox(height: 2),
                      Text(p.$2, style: PremiumTypography.caption.copyWith(color: context.textTertiary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildBuyButton(BuildContext context, bool isDark) {
    return [
      PremiumButton.primary(
        text: 'Buy Now',
        icon: const Icon(Icons.shopping_bag_rounded),
        onPressed: _buy,
        isFullWidth: true,
      ),
      const SizedBox(height: 12),
      Text('Step 1: Enter UID  •  Step 2: Select Pack  •  Step 3: Choose payment',
        textAlign: TextAlign.center,
        style: PremiumTypography.caption.copyWith(color: context.textTertiary)),
    ];
  }
}
