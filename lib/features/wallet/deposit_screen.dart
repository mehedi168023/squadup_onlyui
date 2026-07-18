import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/core/app_toast.dart';
import '../../app/core/app_constants.dart';
import '../../app/core/validators.dart';
import '../../app/data/mock/mock_data.dart';
import '../../app/routes/app_routes.dart';
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

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final amount = TextEditingController();
  int _channel = 0;

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'Add Money',
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
            _buildHeaderCard(context, isDark),
            const SizedBox(height: 24),
            _buildSectionHeader(context, isDark, 'PAYMENT METHOD'),
            const SizedBox(height: 16),
            _buildPaymentMethodDropdown(context, isDark),
            const SizedBox(height: 24),
            _buildSectionHeader(context, isDark, 'ENTER AMOUNT'),
            const SizedBox(height: 16),
            PremiumTextField(
              controller: amount,
              hint: 'Enter amount',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Text(
                  AppConstants.currency,
                  style: PremiumTypography.h5.copyWith(
                    color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildContinueButton(context, isDark),
            const SizedBox(height: 24),
            _buildInfoCard(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, bool isDark) {
    return Container(
      padding: PremiumSpacing.card,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PremiumColors.success.withOpacity(0.15),
            (isDark ? PremiumColors.darkCard : PremiumColors.lightCard).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(PremiumRadius.card),
        border: Border.all(
          color: PremiumColors.success.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: PremiumColors.success.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: PremiumColors.winning,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Money',
                  style: PremiumTypography.h5.copyWith(
                    color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Secure payment via gateway',
                  style: PremiumTypography.caption.copyWith(
                    color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: PremiumColors.winning.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Active',
              style: PremiumTypography.labelSmall.copyWith(
                color: PremiumColors.winning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isDark, String title) {
    return Text(
      title,
      style: PremiumTypography.labelLarge.copyWith(
        color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildPaymentMethodDropdown(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkSurface2 : PremiumColors.lightSurface1,
        borderRadius: BorderRadius.circular(PremiumRadius.input),
        border: Border.all(
          color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
        ),
      ),
      child: DropdownButtonFormField<int>(
        value: _channel,
        isExpanded: true,
        borderRadius: BorderRadius.circular(14),
        dropdownColor: isDark ? PremiumColors.darkCardElevated : PremiumColors.lightCard,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        selectedItemBuilder: (context) => [
          for (final ch in MockData.depositChannels)
            PaymentChannelRow(channel: ch),
        ],
        items: [
          for (int i = 0; i < MockData.depositChannels.length; i++)
            DropdownMenuItem<int>(
              value: i,
              child: PaymentChannelRow(channel: MockData.depositChannels[i]),
            ),
        ],
        onChanged: (v) {
          if (v != null) setState(() => _channel = v);
        },
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, bool isDark) {
    final ch = MockData.depositChannels[_channel];
    final isGateway = ch.key == 'gateway';
    
    return PremiumButton.primary(
      text: isGateway ? 'PROCEED TO PAYMENT' : 'CONTINUE',
      icon: Icon(isGateway ? Icons.lock_rounded : Icons.arrow_forward_rounded),
      onPressed: () {
        final v = double.tryParse(amount.text.trim());
        if (isGateway) {
          final err = Validators.amount(amount.text);
          if (err != null) {
            AppToast.error(err);
            return;
          }
          Get.toNamed(AppRoutes.depositWebview, arguments: v);
        } else {
          Get.toNamed(AppRoutes.manualDeposit,
              arguments: {'channel': ch, 'amount': v});
        }
      },
      isFullWidth: true,
      customColor: PremiumColors.winning,
    );
  }

  Widget _buildInfoCard(BuildContext context, bool isDark) {
    return PremiumCard(
      padding: PremiumSpacing.card,
      child: Column(
        children: [
          _buildInfoRow(
            context,
            isDark,
            Icons.verified_rounded,
            PremiumColors.primary,
            'Secure payment powered by our gateway',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            isDark,
            Icons.bolt_rounded,
            PremiumColors.gold,
            'Balance is credited instantly after payment',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            isDark,
            Icons.headset_mic_rounded,
            PremiumColors.winning,
            'Contact support if payment is not reflected',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    bool isDark,
    IconData icon,
    Color color,
    String text,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: PremiumTypography.body.copyWith(
              color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
