import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/data/mock/mock_data.dart';
import '../../app/data/models/match_model.dart';
import '../../app/data/services/session_service.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionService.to;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: const BrandAppBar(),
      body: RefreshIndicator(
        color: PremiumColors.primary,
        backgroundColor: isDark ? PremiumColors.darkCardElevated : PremiumColors.lightCard,
        onRefresh: session.refreshMatches,
        child: ResponsiveCenter(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              PremiumSpacing.screenHorizontal,
              PremiumSpacing.md,
              PremiumSpacing.screenHorizontal,
              MediaQuery.of(context).padding.bottom + 84,
            ),
            children: [
              const PromoBanner(banners: MockData.homeBanners),
              const SizedBox(height: 24),
              _SectionHeader(
                title: 'CHOOSE YOUR GAME',
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              ...MockData.categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + (index * 100)),
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _PremiumCategoryCard(category: category),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;
  
  const _SectionHeader({
    required this.title,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: PremiumTypography.labelLarge.copyWith(
        color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _PremiumCategoryCard extends StatefulWidget {
  final GameCategory category;
  
  const _PremiumCategoryCard({required this.category});

  @override
  State<_PremiumCategoryCard> createState() => _PremiumCategoryCardState();
}

class _PremiumCategoryCardState extends State<_PremiumCategoryCard> {
  bool _isPressed = false;

  void _open() {
    Get.toNamed(widget.category.key == 'ludo' ? AppRoutes.ludo : AppRoutes.freeFire);
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionService.to;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _open();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: PremiumDurations.buttonPress,
        curve: PremiumCurves.snappy,
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.category.colors,
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
                color: widget.category.colors.first.withOpacity(0.4),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Animated background pattern
              Positioned(
                right: -20,
                bottom: -30,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: PremiumCurves.emphasized,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(
                        opacity: 0.08 * value,
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    widget.category.icon,
                    size: 180,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: PremiumSpacing.cardLarge,
                child: Row(
                  children: [
                    _PremiumIconTile(category: widget.category),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.category.title,
                            style: PremiumTypography.h2.copyWith(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.category.subtitle,
                            style: PremiumTypography.body.copyWith(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Live matches badge
              Positioned(
                top: 16,
                right: 16,
                child: Obx(() {
                  final count = session.matches
                      .where((m) => widget.category.modeKeys.contains(m.modeKey))
                      .length;
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: PremiumDurations.medium,
                    curve: PremiumCurves.springSubtle,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: PremiumColors.gold,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x55FFB800),
                            blurRadius: 12,
                            spreadRadius: 0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sports_esports_rounded,
                            color: Color(0xFF1A1500),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$count',
                            style: PremiumTypography.labelSmall.copyWith(
                              color: const Color(0xFF1A1500),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumIconTile extends StatelessWidget {
  final GameCategory category;
  
  const _PremiumIconTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(PremiumRadius.lg),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: category.image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(PremiumRadius.md),
              child: Image.asset(
                category.image!,
                fit: BoxFit.cover,
                cacheWidth: 180,
              ),
            )
          : Icon(
              category.icon,
              color: Colors.white,
              size: 36,
            ),
    );
  }
}
