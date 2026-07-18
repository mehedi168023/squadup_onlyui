import 'package:flutter/material.dart';
import '../tokens/premium_colors.dart';
import '../tokens/premium_typography.dart';
import 'premium_curves.dart';
import 'premium_durations.dart';

/// Premium feedback overlay - success, error, loading animations
class PremiumFeedbackOverlay extends StatelessWidget {
  final PremiumFeedbackType type;
  final String? title;
  final String? message;
  final double size;

  const PremiumFeedbackOverlay({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          if (title != null) ...[
            const SizedBox(height: 24),
            Text(title!, style: PremiumTypography.h4.copyWith(
              color: context.text,
            )),
          ],
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(message!, style: PremiumTypography.body.copyWith(
              color: context.textSecondary,
            ), textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon() {
    switch (type) {
      case PremiumFeedbackType.success:
        return const _SuccessAnimation(size: 80);
      case PremiumFeedbackType.error:
        return const _ErrorAnimation(size: 80);
      case PremiumFeedbackType.loading:
        return const _PremiumPulseLoader(size: 48);
    }
  }
}

enum PremiumFeedbackType { success, error, loading }

class _SuccessAnimation extends StatefulWidget {
  final double size;
  const _SuccessAnimation({required this.size});

  @override
  State<_SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<_SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: PremiumDurations.medium);
    _scale = CurvedAnimation(parent: _controller, curve: PremiumCurves.springSubtle);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: PremiumColors.success.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: PremiumColors.success.withOpacity(0.3), width: 2),
        ),
        child: const Icon(Icons.check_rounded, color: PremiumColors.success, size: 40),
      ),
    );
  }
}

class _ErrorAnimation extends StatefulWidget {
  final double size;
  const _ErrorAnimation({required this.size});

  @override
  State<_ErrorAnimation> createState() => _ErrorAnimationState();
}

class _ErrorAnimationState extends State<_ErrorAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shake;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: PremiumDurations.medium);
    _shake = Tween(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: PremiumCurves.springBouncy),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shake.value, 0),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: PremiumColors.danger.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: PremiumColors.danger.withOpacity(0.3), width: 2),
            ),
            child: const Icon(Icons.close_rounded, color: PremiumColors.danger, size: 40),
          ),
        );
      },
    );
  }
}

class _PremiumPulseLoader extends StatefulWidget {
  final double size;
  const _PremiumPulseLoader({required this.size});

  @override
  State<_PremiumPulseLoader> createState() => _PremiumPulseLoaderState();
}

class _PremiumPulseLoaderState extends State<_PremiumPulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _pulse = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: PremiumCurves.springSubtle),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulse,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          gradient: PremiumColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: PremiumShadows.primaryGlow,
        ),
        child: const Center(
          child: SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-screen feedback overlay
class PremiumFullScreenFeedback extends StatelessWidget {
  final PremiumFeedbackType type;
  final String? title;
  final String? message;
  final VoidCallback? onDismiss;
  final Widget? action;

  const PremiumFullScreenFeedback({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.onDismiss,
    this.action,
  });

  static void showSuccess(BuildContext context, {String? title, String? message}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => PremiumFullScreenFeedback(
        type: PremiumFeedbackType.success,
        title: title ?? 'Success!',
        message: message,
      ),
    );
  }

  static void showError(BuildContext context, {String? title, String? message}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => PremiumFullScreenFeedback(
        type: PremiumFeedbackType.error,
        title: title ?? 'Error',
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PremiumFeedbackOverlay(type: type, title: title, message: message),
            if (action != null) ...[
              const SizedBox(height: 32),
              action!,
            ],
            if (onDismiss != null) ...[
              const SizedBox(height: 16),
              TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
            ],
          ],
        ),
      ),
    );
  }
}
