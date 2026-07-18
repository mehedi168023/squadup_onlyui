import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/core/app_toast.dart';
import '../../app/core/validators.dart';
import '../../app/data/models/misc_models.dart';
import '../../app/data/services/session_service.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../design_system/components/buttons/premium_button.dart';
import '../../design_system/components/inputs/premium_text_field.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../app/widgets/payment_channel_field.dart';
import '../../app/widgets/responsive.dart';

class ManualDepositScreen extends StatefulWidget {
  const ManualDepositScreen({super.key});

  @override
  State<ManualDepositScreen> createState() => _ManualDepositScreenState();
}

class _ManualDepositScreenState extends State<ManualDepositScreen> {
  late final PaymentChannel channel;
  final amount = TextEditingController();
  final trxId = TextEditingController();
  final senderNumber = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final args = (Get.arguments as Map?) ?? const {};
    channel = (args['channel'] as PaymentChannel?) ??
        const PaymentChannel(
            key: 'bkash', label: 'bKash',
            color: Color(0xFFE2136E), number: '01710000001',
            accountType: 'Personal');
    final prefill = args['amount'] as double?;
    if (prefill != null && prefill > 0) {
      amount.text = prefill.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    amount.dispose();
    trxId.dispose();
    senderNumber.dispose();
    super.dispose();
  }

  void _copyNumber() {
    Clipboard.setData(ClipboardData(text: channel.number ?? ''));
    AppToast.success('${channel.label} number copied');
  }

  Future<void> _submit() async {
    final aErr = Validators.amount(amount.text, min: 1);
    if (aErr != null) { AppToast.error(aErr); return; }
    final tErr = Validators.trxId(trxId.text);
    if (tErr != null) { AppToast.error(tErr); return; }
    final sn = senderNumber.text.trim();
    if (sn.isNotEmpty) {
      final snErr = Validators.phone(sn);
      if (snErr != null) { AppToast.error(snErr); return; }
    }
    final amt = double.parse(amount.text.trim());
    setState(() => _submitting = true);
    final ok = await SessionService.to.submitManualDeposit(
      channelKey: channel.key, amount: amt,
      trxId: trxId.text.trim(), senderNumber: senderNumber.text.trim(),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (!ok) return;
    Get.back();
    AppToast.success('Deposit request sent!');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text('${channel.label} Deposit', style: PremiumTypography.h3.copyWith(
          color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
        )),
      ),
      body: ResponsiveCenter(
        child: ListView(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            _buildNumberCard(context, isDark),
            const SizedBox(height: 20),
            _buildSectionHeader(isDark, 'HOW TO DEPOSIT'),
            const SizedBox(height: 16),
            _buildSteps(context, isDark),
            const SizedBox(height: 24),
            _buildSectionHeader(isDark, 'SUBMIT YOUR PAYMENT'),
            const SizedBox(height: 16),
            PremiumTextField(
              controller: amount,
              label: 'Amount Sent',
              hint: 'Enter amount',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Text(AppConstants.currency, style: PremiumTypography.h5.copyWith(
                  color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                )),
              ),
            ),
            const SizedBox(height: 16),
            _buildTrxField(context, isDark),
            const SizedBox(height: 16),
            _buildSenderField(context, isDark),
            const SizedBox(height: 24),
            PremiumButton.primary(
              text: 'SUBMIT REQUEST',
              icon: const Icon(Icons.send_rounded),
              onPressed: _submitting ? null : _submit,
              isLoading: _submitting,
              isFullWidth: true,
              customColor: PremiumColors.winning,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberCard(BuildContext context, bool isDark) {
    return PremiumCard(
      color: channel.color.withOpacity(0.15),
      border: Border.all(color: channel.color.withOpacity(0.5)),
      padding: PremiumSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: channel.color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(channel.label, style: PremiumTypography.h5.copyWith(
                      color: isDark ? PremiumColors.darkText : PremiumColors.lightText)),
                    Text(channel.accountType ?? '', style: PremiumTypography.caption.copyWith(
                      color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? PremiumColors.darkSurface2 : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(channel.number ?? '', style: PremiumTypography.h5.copyWith(
                  color: Colors.white, letterSpacing: 1)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, color: Colors.white, size: 20),
                  onPressed: _copyNumber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDark, String title) {
    return Text(title, style: PremiumTypography.labelLarge.copyWith(
      color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
      letterSpacing: 1.2, fontWeight: FontWeight.w700,
    ));
  }

  Widget _buildSteps(BuildContext context, bool isDark) {
    final steps = ['Send money to the number above', 'Copy your Transaction ID (TRX)', 'Submit the form below', 'Wait for verification (~few hours)'];
    return Column(
      children: steps.asMap().entries.map((entry) {
        final i = entry.key + 1;
        final step = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 28, height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: PremiumColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('$i', style: PremiumTypography.labelSmall.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 12),
              Text(step, style: PremiumTypography.body.copyWith(color: context.textSecondary)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrxField(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkCard : PremiumColors.lightCard,
        borderRadius: BorderRadius.circular(PremiumRadius.input),
        border: Border.all(color: context.border),
      ),
      child: TextField(
        controller: trxId,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')), LengthLimitingTextInputFormatter(24)],
        style: PremiumTypography.body.copyWith(color: context.text),
        decoration: InputDecoration(
          labelText: 'Transaction ID (TRX)',
          hintText: 'e.g. 9HG7K2LM4P',
          hintStyle: PremiumTypography.body.copyWith(color: context.textTertiary),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.tag_rounded),
          ),
          labelStyle: PremiumTypography.body.copyWith(color: context.textSecondary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSenderField(BuildContext context, bool isDark) {
    return PremiumTextField(
      controller: senderNumber,
      label: 'Your ${channel.label} Number (optional)',
      hint: 'The number you sent money from',
      prefixIcon: const Icon(Icons.phone_rounded),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _submit(),
    );
  }

  Widget _buildInfoCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PremiumColors.gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(PremiumRadius.md),
        border: Border.all(color: PremiumColors.gold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: PremiumColors.gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text('Send money first, then submit. Your balance is added after we verify the Transaction ID.',
                style: PremiumTypography.bodySmall.copyWith(color: context.text, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
