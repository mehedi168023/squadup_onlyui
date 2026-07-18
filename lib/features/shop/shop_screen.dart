import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/data/mock/mock_data.dart';
import '../../app/routes/app_routes.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/animations/premium_curves.dart';
import '../../design_system/animations/premium_durations.dart';
import '../../app/widgets/brand_app_bar.dart';
import '../../app/widgets/promo_banner.dart';
import '../../app/widgets/responsive.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: const BrandAppBar(),
      body: ResponsiveCenter(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            PremiumSpacing.screenHorizontal,
            PremiumSpacing.md,
            PremiumSpacing.screenHorizontal,
            MediaQuery.of(context).padding.bottom + 84,
          ),
          children: [
            const PromoBanner(banners: MockData.shopBanners),
            const SizedBox(height: 24),
            Text(
              'STORE',
              style: PremiumTypography.labelLarge.copyWith(
                color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const _PremiumStoreGrid(),
          ],
        ),
      ),
    );
  }
}

class _PremiumStoreGrid extends StatelessWidget {
  const _PremiumStoreGrid();

  @override
  Widget build(BuildContext context) {
    final ff = MockData.topupCategories[0];
    final kingpass = MockData.topupCategories[1];
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.95,
      children: [
        _PremiumStoreTile(
          image: ff.image,
          title: 'Free Fire Topup',
          subtitle: 'Diamonds · Instant',
          colors: ff.colors,
          index: 0,
          onTap: () => Get.toNamed(AppRoutes.topup, arguments: ff),
        ),
        _PremiumStoreTile(
          image: kingpass.image,
          title: 'Ludo Kingpass',
          subtitle: 'Coins · Discount',
          colors: kingpass.colors,
          index: 1,
          onTap: () => Get.toNamed(AppRoutes.topup, arguments: kingpass),
        ),
        _PremiumStoreTile(
          image: AppConstants.shopGamingLogo,
          title: 'Gaming Store',
          subtitle: 'Gadgets & gear',
          colors: const [Color(0xFF2A0A40), Color(0xFF120A26)],
          index: 2,
          onTap: () => Get.toNamed(AppRoutes.products),
        ),
      ],
    );
  }
}

class _PremiumStoreTile extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final int index;
  final VoidCallback onTap;
  
  const _PremiumStoreTile({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.index,
    required this.onTap,
  });

  @override
  State<_PremiumStoreTile> createState() => _PremiumStoreTileState();
}

class _PremiumStoreTileState extends State<_PremiumStoreTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (widget.index * 100)),
      curve: PremiumCurves.emphasized,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: PremiumDurations.buttonPress,
          curve: PremiumCurves.snappy,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(PremiumRadius.cardLarge),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.colors.first.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
                  cacheWidth: 360,
                  filterQuality: FilterQuality.low,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: PremiumTypography.h5.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: PremiumTypography.caption.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 11,
                        ),
                      ),
                    ],
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
