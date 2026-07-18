import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_toast.dart';
import '../../app/core/validators.dart';
import '../../app/data/services/session_service.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/components/buttons/premium_button.dart';
import '../../design_system/components/inputs/premium_text_field.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../app/widgets/responsive.dart';

class EditProfileController extends GetxController {
  final session = SessionService.to;
  final profileKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  late final TextEditingController name;
  late final TextEditingController email;
  late final TextEditingController phone;
  final current = TextEditingController();
  final next = TextEditingController();
  final confirm = TextEditingController();
  final savingProfile = false.obs;
  final savingPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    final u = session.user.value;
    name = TextEditingController(text: u?.name ?? '');
    email = TextEditingController(text: u?.email ?? '');
    phone = TextEditingController(text: u?.phone ?? '');
  }

  Future<void> updateProfile() async {
    if (!(profileKey.currentState?.validate() ?? false)) return;
    savingProfile.value = true;
    await session.updateProfile(name: name.text.trim());
    savingProfile.value = false;
    AppToast.success('Profile updated');
  }

  Future<void> changePassword() async {
    if (!(passwordKey.currentState?.validate() ?? false)) return;
    savingPassword.value = true;
    final ok = await session.changePassword(current.text, next.text);
    savingPassword.value = false;
    if (ok) {
      current.clear();
      next.clear();
      confirm.clear();
      AppToast.success('Password changed');
    } else {
      AppToast.error('Failed to change password');
    }
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    current.dispose();
    next.dispose();
    confirm.dispose();
    super.onClose();
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EditProfileController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'Edit Profile',
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
            Text(
              'BASIC INFORMATION',
              style: PremiumTypography.labelLarge.copyWith(
                color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: c.profileKey,
              child: Column(
                children: [
                  PremiumTextField(
                    controller: c.name,
                    label: 'Full Name',
                    hint: 'Your name',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => c.updateProfile(),
                  ),
                  const SizedBox(height: 16),
                  PremiumTextField(
                    controller: c.email,
                    label: 'Email Address',
                    hint: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  PremiumTextField(
                    controller: c.phone,
                    label: 'Phone Number',
                    hint: 'Phone',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    enabled: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => PremiumButton.primary(
                  text: 'UPDATE PROFILE',
                  onPressed: c.savingProfile.value ? null : c.updateProfile,
                  isLoading: c.savingProfile.value,
                  isFullWidth: true,
                )),
            const SizedBox(height: 40),
            Divider(
              color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
              thickness: 1,
            ),
            const SizedBox(height: 32),
            Text(
              'CHANGE PASSWORD',
              style: PremiumTypography.labelLarge.copyWith(
                color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: c.passwordKey,
              child: Column(
                children: [
                  PremiumPasswordField(
                    controller: c.current,
                    label: 'Current Password',
                    hint: 'Enter current password',
                  ),
                  const SizedBox(height: 16),
                  PremiumPasswordField(
                    controller: c.next,
                    label: 'New Password',
                    hint: 'At least 8 chars, 1 letter & 1 number',
                  ),
                  const SizedBox(height: 16),
                  PremiumPasswordField(
                    controller: c.confirm,
                    label: 'Confirm New Password',
                    hint: 'Confirm new password',
                    onSubmitted: (_) => c.changePassword(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => PremiumButton.primary(
                  text: 'CHANGE PASSWORD',
                  onPressed: c.savingPassword.value ? null : c.changePassword,
                  isLoading: c.savingPassword.value,
                  isFullWidth: true,
                  customColor: PremiumColors.danger,
                )),
          ],
        ),
      ),
    );
  }
}
