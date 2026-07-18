import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/data/mock/mock_data.dart';
import '../../app/data/models/misc_models.dart';
import '../../app/routes/app_routes.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/animations/premium_curves.dart';
import '../../design_system/animations/premium_durations.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../design_system/tokens/premium_shadows.dart';
import '../../app/widgets/responsive.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'Gaming Products',
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      body: ResponsiveCenter(
        child: GridView.builder(
          padding: EdgeInsets.fromLTRB(
            PremiumSpacing.screenHorizontal,
            PremiumSpacing.md,
            PremiumSpacing.screenHorizontal,
            MediaQuery.of(context).padding.bottom + 24,
          ),
          itemCount: MockData.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.76,
          ),
          itemBuilder: (_, i) => TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 200 + (i * 50)),
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
            child: _PremiumProductCard(product: MockData.products[i]),
          ),
        ),
      ),
    );
  }
}

class _PremiumProductCard extends StatefulWidget {
  final Product product;
  const _PremiumProductCard({required this.product});

  @override
  State<_PremiumProductCard> createState() => _PremiumProductCardState();
}

class _PremiumProductCardState extends State<_PremiumProductCard> {
  bool _isPressed = false;

  void _openBuy() => Get.toNamed(AppRoutes.productBuy, arguments: widget.product);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _openBuy();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: PremiumDurations.buttonPress,
        curve: PremiumCurves.snappy,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? PremiumColors.darkCard : PremiumColors.lightCard,
            borderRadius: BorderRadius.circular(PremiumRadius.card),
            border: Border.all(
              color: isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder,
            ),
            boxShadow: isDark ? PremiumShadows.darkCard : PremiumShadows.lightCard,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        PremiumColors.primary.withOpacity(0.15),
                        PremiumColors.primary.withOpacity(0.05),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: widget.product.image != null
                      ? Image.asset(
                          widget.product.image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          cacheWidth: 360,
                          errorBuilder: (_, __, ___) => Icon(
                            widget.product.icon,
                            size: 56,
                            color: PremiumColors.primary,
                          ),
                        )
                      : Icon(
                          widget.product.icon,
                          size: 56,
                          color: PremiumColors.primary,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: PremiumTypography.label.copyWith(
                        color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          taka(widget.product.price),
                          style: PremiumTypography.bodyMedium.copyWith(
                            color: PremiumColors.winning,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (widget.product.oldPrice != null)
                          Text(
                            taka(widget.product.oldPrice!),
                            style: PremiumTypography.caption.copyWith(
                              color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildBuyButton(isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuyButton(bool isDark) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        gradient: PremiumColors.primaryGradient,
        borderRadius: BorderRadius.circular(PremiumRadius.sm),
        boxShadow: PremiumShadows.primaryGlow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openBuy,
          borderRadius: BorderRadius.circular(PremiumRadius.sm),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_bag_rounded,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  'Buy Now',
                  style: PremiumTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
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
