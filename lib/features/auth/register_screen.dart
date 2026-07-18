import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/core/validators.dart';
import '../../app/data/models/heads_up_notification.dart';
import '../../app/data/services/notification_service.dart';
import '../../app/data/services/session_service.dart';
import '../../app/routes/app_routes.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/buttons/premium_button.dart';
import '../../design_system/components/inputs/premium_text_field.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../design_system/tokens/premium_shadows.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final identifier = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  final refer = TextEditingController();
  final loading = false.obs;
  final passwordValue = ''.obs;

  @override
  void onClose() {
    name.dispose();
    identifier.dispose();
    password.dispose();
    confirm.dispose();
    refer.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    loading.value = true;
    final ok = await SessionService.to.register(
      name.text.trim(),
      identifier.text.trim(),
      password.text,
      referCode: refer.text.trim(),
    );
    loading.value = false;
    if (!ok) return;
    Get.offAllNamed(AppRoutes.shell);
    NotificationService.to.showHeadsUp(
      HeadsUpNotification(
        id: 'reg_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Registration Successful 🎉',
        message: 'Welcome to SquadUp! Your account is ready.',
        icon: 'success',
        sound: 'success',
      ),
      osNotify: true,
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(RegisterController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'Create Account',
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: c.formKey,
          child: SingleChildScrollView(
            padding: PremiumSpacing.screenHorizontalOnly.add(
              const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? PremiumColors.darkSurface2 : PremiumColors.lightCard,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: isDark ? PremiumShadows.darkCard : PremiumShadows.lightCard,
                  ),
                  child: Image.asset(
                    AppConstants.logo,
                    width: 80,
                    height: 80,
                    cacheWidth: 240,
                  ),
                ),
                const SizedBox(height: 24),
                PremiumTextField(
                  controller: c.name,
                  label: 'Full Name',
                  hint: 'Enter your name',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                PremiumTextField(
                  controller: c.identifier,
                  label: 'Phone or Email',
                  hint: 'Enter your phone or email',
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                PremiumPasswordField(
                  controller: c.password,
                  label: 'Password',
                  hint: 'At least 8 chars, 1 letter & 1 number',
                  onChanged: (v) => c.passwordValue.value = v,
                ),
                const SizedBox(height: 12),
                Obx(() => _PremiumPasswordStrength(password: c.passwordValue.value)),
                const SizedBox(height: 16),
                PremiumPasswordField(
                  controller: c.confirm,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                ),
                const SizedBox(height: 16),
                PremiumTextField(
                  controller: c.refer,
                  label: 'Refer Code (Optional)',
                  hint: 'Enter refer code if any',
                  prefixIcon: const Icon(Icons.card_giftcard_rounded),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => c.submit(),
                ),
                const SizedBox(height: 24),
                Obx(() => PremiumButton.primary(
                      text: 'Register',
                      onPressed: c.loading.value ? null : c.submit,
                      isLoading: c.loading.value,
                      isFullWidth: true,
                    )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: PremiumTypography.body.copyWith(
                        color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        'Login',
                        style: PremiumTypography.bodyMedium.copyWith(
                          color: PremiumColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: PremiumColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumPasswordStrength extends StatelessWidget {
  final String password;
  
  const _PremiumPasswordStrength({required this.password});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (password.isEmpty) return const SizedBox.shrink();
    
    final s = Validators.strength(password);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(PremiumRadius.full),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: s.score),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 6,
                    backgroundColor: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightBorderSubtle,
                    valueColor: AlwaysStoppedAnimation<Color>(s.color),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 200),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            child: Text(
              s.label,
              style: PremiumTypography.labelSmall.copyWith(
                color: s.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
