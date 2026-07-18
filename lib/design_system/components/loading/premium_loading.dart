import 'package:flutter/material.dart';
import '../../tokens/premium_colors.dart';
import '../../tokens/premium_radius.dart';
import '../../animations/premium_animations.dart';

/// Premium loading and shimmer components
/// Smooth skeleton loading with premium animations
class PremiumShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  
  const PremiumShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });
  
  const PremiumShimmerLoading.rectangular({
    super.key,
    required this.width,
    required this.height,
  }) : borderRadius = null;
  
  const PremiumShimmerLoading.circular({
    super.key,
    required double size,
  }) : width = size,
       height = size,
       borderRadius = const BorderRadius.all(Radius.circular(9999));

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumShimmer(
      baseColor: isDark ? PremiumColors.darkSurface2 : PremiumColors.lightBorderSubtle,
      highlightColor: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface2,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? PremiumColors.darkSurface2 : PremiumColors.lightBorderSubtle,
          borderRadius: borderRadius ?? BorderRadius.circular(PremiumRadius.sm),
        ),
      ),
    );
  }
}

/// Shimmer loading for card
class PremiumShimmerCard extends StatelessWidget {
  final double? height;
  
  const PremiumShimmerCard({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumShimmerLoading(
      width: double.infinity,
      height: height ?? 120,
      borderRadius: BorderRadius.circular(PremiumRadius.card),
    );
  }
}

/// Shimmer loading for text line
class PremiumShimmerText extends StatelessWidget {
  final double width;
  final double height;
  
  const PremiumShimmerText({
    super.key,
    this.width = double.infinity,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumShimmerLoading(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
    );
  }
}

/// Shimmer loading for avatar/circle
class PremiumShimmerAvatar extends StatelessWidget {
  final double size;
  
  const PremiumShimmerAvatar({
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumShimmerLoading.circular(
      size: size,
    );
  }
}

/// Premium circular progress indicator
class PremiumCircularProgress extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  
  const PremiumCircularProgress({
    super.key,
    this.size = 48,
    this.color,
    this.strokeWidth = 3,
  });
  
  const PremiumCircularProgress.small({
    super.key,
    this.color,
  }) : size = 24,
       strokeWidth = 2.5;
  
  const PremiumCircularProgress.large({
    super.key,
    this.color,
  }) : size = 64,
       strokeWidth = 4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? PremiumColors.primary,
        ),
      ),
    );
  }
}

/// Premium linear progress indicator
class PremiumLinearProgress extends StatelessWidget {
  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final BorderRadius? borderRadius;
  
  const PremiumLinearProgress({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.height = 4,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? PremiumColors.primary,
          ),
          backgroundColor: backgroundColor ??
              (isDark ? PremiumColors.darkSurface3 : PremiumColors.lightBorderSubtle),
        ),
      ),
    );
  }
}

/// Full screen loading overlay
class PremiumLoadingOverlay extends StatelessWidget {
  final String? message;
  
  const PremiumLoadingOverlay({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      color: (isDark ? PremiumColors.darkBg : PremiumColors.lightBg).withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PremiumCircularProgress(),
            if (message != null) ...[
              const SizedBox(height: 24),
              Text(
                message!,
                style: TextStyle(
                  color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton loading for list items
class PremiumSkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  
  const PremiumSkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => PremiumShimmerCard(height: itemHeight),
    );
  }
}
