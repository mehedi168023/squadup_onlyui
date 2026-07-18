import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/core/app_constants.dart';
import 'app/core/initial_binding.dart';
import 'app/core/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'design_system/tokens/premium_colors.dart';
import 'design_system/theme/premium_theme.dart';
import 'design_system/components/premium_performance.dart';
import 'design_system/animations/premium_durations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: PremiumColors.darkBg,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  InitialBinding().dependencies();
  runApp(const SquadUpApp());
}

class SquadUpApp extends StatelessWidget {
  const SquadUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: PremiumTheme.light,
          darkTheme: PremiumTheme.dark,
          themeMode: ThemeController.to.mode.value,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.routes,
          defaultTransition: Transition.cupertino,
          transitionDuration: PremiumDurations.normal,
          opaqueRoute: true,
          builder: (context, child) {
            final media = MediaQuery.of(context);
            final factor = (media.size.width / 420).clamp(0.85, 1.0);
            return PremiumImagePreloader(
              assets: [
                AppConstants.logo,
                AppConstants.freefireLogo,
                AppConstants.ludoClassic,
                AppConstants.ludoAuto,
                AppConstants.bannerAddMoney,
                AppConstants.bannerHowToPlay,
                AppConstants.bannerJoinGroup,
                AppConstants.shopProductsBanner,
                AppConstants.shopTopupBanner,
              ],
              child: MediaQuery(
                data: media.copyWith(textScaler: TextScaler.linear(factor)),
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        ));
  }
}
