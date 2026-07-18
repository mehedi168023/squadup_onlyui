import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/data/services/session_service.dart';
import '../../app/routes/app_routes.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/animations/premium_curves.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final Animation<double> _introFade =
      CurvedAnimation(parent: _intro, curve: PremiumCurves.emphasized);
  late final Animation<double> _introScale = Tween<double>(begin: 0.85, end: 1.0)
      .chain(CurveTween(curve: PremiumCurves.emphasized))
      .animate(_intro);

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _intro.forward();
    _boot();
  }

  Future<void> _boot() async {
    final results = await Future.wait([
      SessionService.to.tryAutoLogin(),
      Future.delayed(const Duration(milliseconds: 1200)),
    ]);
    if (!mounted) return;
    final loggedIn = results[0] == true;
    Get.offAllNamed(loggedIn ? AppRoutes.shell : AppRoutes.login);
  }

  @override
  void dispose() {
    _intro.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumColors.darkBg,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              PremiumColors.primary.withOpacity(0.15),
              PremiumColors.darkBg,
              PremiumColors.darkBg,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _introFade,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _introScale,
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          PremiumColors.primary.withOpacity(0.3),
                          PremiumColors.primary.withOpacity(0.1),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: Hero(
                      tag: 'brand-logo',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x557C3AED),
                              blurRadius: 40,
                              spreadRadius: 0,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.asset(
                            AppConstants.logo,
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                            cacheWidth: 400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  AppConstants.appName,
                  style: PremiumTypography.display2.copyWith(
                    color: PremiumColors.darkText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppConstants.tagline.toUpperCase(),
                  style: PremiumTypography.label.copyWith(
                    color: PremiumColors.darkTextSecondary,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 60),
                ScaleTransition(
                  scale: Tween(begin: 0.8, end: 1.2).animate(
                    CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                  ),
                  child: Transform.rotate(
                    angle: 0.785398,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        gradient: PremiumColors.primaryGradient,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: PremiumColors.primary.withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
