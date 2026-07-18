import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/core/notice_popup.dart';
import '../../app/data/services/permission_service.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/tokens/premium_shadows.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../shop/shop_screen.dart';

class ShellController extends GetxController {
  static ShellController get to => Get.find();

  final index = 1.obs;
  void go(int i) => index.value = i;

  bool _precached = false;

  void precacheFirstScreenImages(BuildContext context) {
    if (_precached) return;
    _precached = true;
    const assets = <String>[
      AppConstants.logo,
      AppConstants.freefireLogo,
      AppConstants.ludoClassic,
      AppConstants.ludoAuto,
      AppConstants.bannerAddMoney,
      AppConstants.bannerHowToPlay,
      AppConstants.bannerJoinGroup,
      AppConstants.shopProductsBanner,
      AppConstants.shopTopupBanner,
      AppConstants.shopGamingLogo,
    ];
    for (final a in assets) {
      precacheImage(AssetImage(a), context, onError: (_, __) {});
    }
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => NoticePopup.showIfFirstLaunch());
    Future(() => PermissionService.to.requestAll());
  }
}

class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  static const _tabs = [ShopScreen(), HomeScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ShellController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) c.precacheFirstScreenImages(context);
    });
    return Scaffold(
      extendBody: true,
      body: Obx(() => IndexedStack(index: c.index.value, children: _tabs)),
      bottomNavigationBar:
          Obx(() => _PremiumNavBar(current: c.index.value, onTap: c.go)),
    );
  }
}

class _PremiumNavBar extends StatefulWidget {
  final int current;
  final ValueChanged<int> onTap;
  const _PremiumNavBar({required this.current, required this.onTap});

  @override
  State<_PremiumNavBar> createState() => _PremiumNavBarState();
}

class _PremiumNavBarState extends State<_PremiumNavBar>
    with SingleTickerProviderStateMixin {
  static const _items = [
    (Icons.storefront_outlined, Icons.storefront_rounded, 'Shop'),
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  static const _spring = SpringDescription(mass: 1, stiffness: 380, damping: 34);
  static const _pop = Duration(milliseconds: 350);

  late final AnimationController _pos = AnimationController.unbounded(
    vsync: this,
    value: widget.current.toDouble(),
  )..addListener(_tick);

  void _tick() => setState(() {});

  @override
  void didUpdateWidget(covariant _PremiumNavBar old) {
    super.didUpdateWidget(old);
    if (old.current != widget.current) {
      _pos.animateWith(SpringSimulation(
          _spring, _pos.value, widget.current.toDouble(), _pos.velocity));
    }
  }

  @override
  void dispose() {
    _pos.dispose();
    super.dispose();
  }

  void _tap(int i) {
    HapticFeedback.lightImpact();
    widget.onTap(i);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final maxIndex = (_items.length - 1).toDouble();
    
    return RepaintBoundary(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Container(
            height: 64,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? PremiumColors.darkSurface1 : PremiumColors.lightCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
                width: 1,
              ),
              boxShadow: isDark ? PremiumShadows.darkCardElevated : PremiumShadows.lightCardElevated,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final slot = constraints.maxWidth / _items.length;
                final pos = _pos.value.clamp(0.0, maxIndex);
                return Stack(
                  children: [
                    Positioned(
                      left: pos * slot,
                      top: 0,
                      bottom: 0,
                      width: slot,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          gradient: PremiumColors.primaryGradient,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x557C3AED),
                              blurRadius: 16,
                              spreadRadius: 0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(_items.length, (i) {
                        final active = i == widget.current;
                        final item = _items[i];
                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _tap(i),
                            child: TweenAnimationBuilder<double>(
                              duration: _pop,
                              curve: Curves.easeOutCubic,
                              tween: Tween(end: active ? 1.0 : 0.0),
                              builder: (_, t, __) {
                                final tc = t.clamp(0.0, 1.0);
                                final inactiveColor = isDark
                                    ? PremiumColors.darkTextTertiary
                                    : PremiumColors.lightTextTertiary;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.translate(
                                      offset: Offset(0, -2 * tc),
                                      child: Transform.scale(
                                        scale: 1 + 0.12 * tc,
                                        child: Icon(
                                          active ? item.$2 : item.$1,
                                          size: 22,
                                          color: Color.lerp(
                                            inactiveColor,
                                            Colors.white,
                                            tc,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item.$3,
                                      style: PremiumTypography.labelSmall.copyWith(
                                        color: Color.lerp(
                                          inactiveColor,
                                          Colors.white,
                                          tc,
                                        ),
                                        fontWeight: tc > 0.5
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
