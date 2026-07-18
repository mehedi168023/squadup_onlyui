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
import '../../design_system/animations/premium_curves.dart';
import '../../design_system/animations/premium_durations.dart';
import '../../app/widgets/auth_backdrop.dart';
import '../../app/widgets/glass.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final identifier = TextEditingController();
  final password = TextEditingController();
  final googleLoading = false.obs;
  final emailLoading = false.obs;

  @override
  void onClose() {
    identifier.dispose();
    password.dispose();
    super.onClose();
  }

  Future<void> signInWithGoogle() async {
    googleLoading.value = true;
    final ok = await SessionService.to.loginWithGoogle(
        'mock-google-id-token-${DateTime.now().millisecondsSinceEpoch}');
    googleLoading.value = false;
    if (!ok) return;
    _enter();
  }

  Future<void> submitEmail() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    emailLoading.value = true;
    final ok =
        await SessionService.to.login(identifier.text.trim(), password.text);
    emailLoading.value = false;
    if (!ok) return;
    _enter();
  }

  void _enter() {
    Get.offAllNamed(AppRoutes.shell);
    final name = SessionService.to.user.value?.name ?? 'Champion';
    Future.delayed(const Duration(milliseconds: 400), () {
      NotificationService.to.showHeadsUp(
        HeadsUpNotification(
          id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Welcome, $name! 👋',
          message: 'Ready to compete? Join a tournament and win big rewards.',
          icon: 'success',
          priority: NotifPriority.normal,
        ),
      );
      NotificationService.to.notifyLoginSuccess();
    });
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LoginController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          const AuthBackdrop(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: PremiumSpacing.all24,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: PremiumDurations.slow,
                  curve: PremiumCurves.emphasized,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: 0.95 + (0.05 * value),
                        child: child,
                      ),
                    );
                  },
                  child: GlassSurface(
                    blur: 18,
                    opacity: 0.5,
                    borderRadius: BorderRadius.circular(PremiumRadius.cardLarge),
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: c.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Hero(
                            tag: 'brand-logo',
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: PremiumColors.primary.withOpacity(0.5),
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x337C3AED),
                                    blurRadius: 24,
                                    spreadRadius: 0,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  AppConstants.logo,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                  cacheWidth: 240,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Welcome to ${AppConstants.appName}',
                            style: PremiumTypography.h2.copyWith(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to join tournaments & win rewards',
                            textAlign: TextAlign.center,
                            style: PremiumTypography.body.copyWith(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Obx(() => PremiumButton.primary(
                                text: 'Continue with Google',
                                icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                                onPressed: c.googleLoading.value ? null : c.signInWithGoogle,
                                isLoading: c.googleLoading.value,
                                isFullWidth: true,
                                customColor: Colors.white,
                              )),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.2),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'or',
                                  style: PremiumTypography.body.copyWith(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.2),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          PremiumTextField(
                            controller: c.identifier,
                            label: 'Phone or Email',
                            hint: 'Enter your phone or email',
                            prefixIcon: const Icon(Icons.person_outline_rounded),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          PremiumPasswordField(
                            controller: c.password,
                            label: 'Password',
                            hint: 'Enter your password',
                            onSubmitted: (_) => c.submitEmail(),
                          ),
                          const SizedBox(height: 24),
                          Obx(() => PremiumButton.primary(
                                text: 'Login',
                                onPressed: c.emailLoading.value ? null : c.submitEmail,
                                isLoading: c.emailLoading.value,
                                isFullWidth: true,
                                customColor: PremiumColors.winning,
                              )),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: PremiumTypography.body.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.toNamed(AppRoutes.register),
                                child: Text(
                                  'Register',
                                  style: PremiumTypography.bodyMedium.copyWith(
                                    color: PremiumColors.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: PremiumColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Version ${AppConstants.appVersion}',
                            style: PremiumTypography.caption.copyWith(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
