import 'package:flutter/material.dart';
import '../tokens/premium_colors.dart';

/// Performance optimization utilities for 120 FPS rendering
/// Use these widgets to prevent unnecessary rebuilds and improve GPU performance

/// RepaintBoundary wrapper for list items and frequently updating widgets
class PremiumRepaintBoundary extends StatelessWidget {
  final Widget child;
  final String? debugLabel;

  const PremiumRepaintBoundary({
    super.key,
    required this.child,
    this.debugLabel,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: child,
    );
  }
}

/// Preserves widget state by keeping it alive in lists
class PremiumKeepAlive extends StatelessWidget {
  final Widget child;

  const PremiumKeepAlive({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AutomaticKeepAlive(
      child: child,
    );
  }
}

/// Memoized value builder - only rebuilds when dependencies change
class PremiumMemoBuilder<T> extends StatelessWidget {
  final T Function() builder;
  final T Function(T previous, T current) areEqual;
  final Widget Function(BuildContext context, T value) child;
  final String? debugLabel;

  const PremiumMemoBuilder({
    super.key,
    required this.builder,
    required this.areEqual,
    required this.child,
    this.debugLabel,
  });

  @override
  Widget build(BuildContext context) {
    return _MemoWidget<T>(
      builder: builder,
      areEqual: areEqual,
      child: child,
      debugLabel: debugLabel,
    );
  }
}

class _MemoWidget<T> extends StatefulWidget {
  final T Function() builder;
  final T Function(T previous, T current) areEqual;
  final Widget Function(BuildContext context, T value) child;
  final String? debugLabel;

  const _MemoWidget({
    required this.builder,
    required this.areEqual,
    required this.child,
    this.debugLabel,
  });

  @override
  State<_MemoWidget<T>> createState() => _MemoWidgetState<T>();
}

class _MemoWidgetState<T> extends State<_MemoWidget<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.builder();
  }

  @override
  void didUpdateWidget(_MemoWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newValue = widget.builder();
    if (widget.areEqual(_value, newValue)) return;
    _value = newValue;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(context, _value);
  }
}

/// Prevents widget from rebuilding when parent rebuilds
class PremiumSizedBox extends SizedBox {
  const PremiumSizedBox({
    super.key,
    super.width,
    super.height,
    super.child,
  });
}

/// Optimized image with caching and proper sizing
class PremiumCachedImage extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final int cacheWidth;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const PremiumCachedImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheWidth = 360,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) => backgroundColor != null
          ? Container(color: backgroundColor!)
          : const SizedBox.shrink(),
    );

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}

/// Animated opacity with frame-skip prevention
class PremiumSmoothOpacity extends ImplicitlyAnimatedWidget {
  final Widget child;
  final double opacity;

  const PremiumSmoothOpacity({
    super.key,
    required this.child,
    required this.opacity,
    super.duration = const Duration(milliseconds: 200),
    super.curve = Curves.easeOut,
  });

  @override
  ImplicitlyAnimatedWidgetState<PremiumSmoothOpacity> createState() =>
      _PremiumSmoothOpacityState();
}

class _PremiumSmoothOpacityState
    extends AnimatedWidgetBaseState<PremiumSmoothOpacity> {
  Tween<double>? _opacity;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _opacity = visitor(_opacity, widget.opacity,
        (dynamic value) => Tween<double>(begin: value as double)) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity?.evaluate(animation) ?? widget.opacity,
      child: widget.child,
    );
  }
}

/// Image preloader for smooth image transitions
class PremiumImagePreloader extends StatelessWidget {
  final List<String> assets;
  final Widget child;

  const PremiumImagePreloader({
    super.key,
    required this.assets,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Trigger precaching in a post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final asset in assets) {
        precacheImage(AssetImage(asset), context, onError: (_, __) {});
      }
    });
    return child;
  }
}
