import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/core/app_toast.dart';
import '../../app/core/validators.dart';
import '../../app/data/mock/mock_data.dart';
import '../../app/data/models/heads_up_notification.dart';
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
import '../../app/widgets/payment_channel_field.dart';
import '../../app/widgets/responsive.dart';

class WithdrawController extends GetxController {
  final channel = 0.obs;
  final number = TextEditingController();
  final amount = TextEditingController();
  final loading = false.obs;

  @override
  void onClose() {
    number.dispose();
    amount.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    final pErr = Validators.phone(number.text);
    if (pErr != null) {
      AppToast.error(pErr);
      return;
    }
    final aErr = Validators.amount(amount.text,
        min: MockData.minWithdraw, max: MockData.maxWithdraw);
    if (aErr != null) {
      AppToast.error(aErr);
      return;
    }
    final amt = double.parse(amount.text.trim());
    loading.value = true;
    final ch = MockData.withdrawChannels[channel.value];
    final ok =
        await SessionService.to.withdraw(amt, ch.key, number.text.trim());
    loading.value = false;
    if (!ok) return;
    Get.back();
    NotificationService.to.showHeadsUp(
      HeadsUpNotification(
        id: 'wd_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Withdraw Requested',
        message: '${taka(amt)} withdrawal to ${ch.label} is being processed.',
        kind: NotifKind.push,
        icon: 'wallet',
      ),
      osNotify: true,
    );
  }
}

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(WithdrawController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const channels = MockData.withdrawChannels;

    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'Withdraw',
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
            _buildSectionHeader(context, isDark, 'PAYMENT CHANNEL'),
            const SizedBox(height: 16),
            _buildChannelDropdown(context, isDark, c, channels),
            const SizedBox(height: 24),
            _buildSectionHeader(context, isDark, 'WALLET DETAILS'),
            const SizedBox(height: 16),
            PremiumTextField(
              controller: c.number,
              label: 'Wallet Number',
              hint: '01XXXXXXXXX',
              prefixIcon: const Icon(Icons.phone_android_rounded),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            PremiumTextField(
              controller: c.amount,
              label: 'Amount',
              hint: 'Enter amount to withdraw',
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
              onSubmitted: (_) => c.submit(),
            ),
            const SizedBox(height: 12),
            Text(
              'Min: ${taka(MockData.minWithdraw)}  ·  Max: ${taka(MockData.maxWithdraw)}',
              style: PremiumTypography.caption.copyWith(
                color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => PremiumButton.primary(
                  text: 'WITHDRAW',
                  icon: const Icon(Icons.arrow_upward_rounded),
                  onPressed: c.loading.value ? null : c.submit,
                  isLoading: c.loading.value,
                  isFullWidth: true,
                  customColor: PremiumColors.danger,
                )),
            const SizedBox(height: 24),
            _buildBalanceCard(context, isDark),
            const SizedBox(height: 16),
            _buildNoticeCard(context, isDark),
          ],
        ),
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

  Widget _buildChannelDropdown(
    BuildContext context,
    bool isDark,
    WithdrawController c,
    List<dynamic> channels,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkSurface2 : PremiumColors.lightSurface1,
        borderRadius: BorderRadius.circular(PremiumRadius.input),
        border: Border.all(
          color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
        ),
      ),
      child: Obx(() => DropdownButtonFormField<int>(
            value: c.channel.value,
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
            selectedItemBuilder: (context) => List.generate(
              channels.length,
              (i) => PaymentChannelRow(channel: channels[i]),
            ),
            items: List.generate(
              channels.length,
              (i) => DropdownMenuItem<int>(
                value: i,
                child: PaymentChannelRow(channel: channels[i]),
              ),
            ),
            onChanged: (v) {
              if (v != null) c.channel.value = v;
            },
          )),
    );
  }

  Widget _buildBalanceCard(BuildContext context, bool isDark) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      color: PremiumColors.winning.withOpacity(0.1),
      border: Border.all(
        color: PremiumColors.winning.withOpacity(0.3),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: PremiumColors.winning.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              color: PremiumColors.winning,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Your Withdrawal Balance is:',
              style: PremiumTypography.body.copyWith(
                color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
              ),
            ),
          ),
          Obx(() => Text(
                taka(SessionService.to.wallet.value.withdrawableBalance),
                style: PremiumTypography.h4.copyWith(
                  color: PremiumColors.winning,
                  fontWeight: FontWeight.w800,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PremiumColors.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(PremiumRadius.card),
        border: Border.all(
          color: PremiumColors.success.withOpacity(0.3),
        ),
      ),
      child: Text(
        MockData.withdrawNotice,
        style: PremiumTypography.body.copyWith(
          color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
          height: 1.6,
        ),
      ),
    );
  }
}
