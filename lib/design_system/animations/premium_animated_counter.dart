import 'dart:math';
import 'package:flutter/material.dart';
import '../tokens/premium_colors.dart';
import '../tokens/premium_typography.dart';
import 'premium_curves.dart';
import 'premium_durations.dart';

/// Premium animated counter for wallet balances, prize pools, stats
/// Smooth number rolling animation with spring physics
class PremiumAnimatedCounter extends StatefulWidget {
  final double targetValue;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final Duration duration;
  final Curve curve;
  final bool showDecimal;
  final bool autoAnimate;

  const PremiumAnimatedCounter({
    super.key,
    required this.targetValue,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.duration = const Duration(milliseconds: 800),
    this.curve = PremiumCurves.emphasized,
    this.showDecimal = false,
    this.autoAnimate = true,
  });

  @override
  State<PremiumAnimatedCounter> createState() => _PremiumAnimatedCounterState();
}

class _PremiumAnimatedCounterState extends State<PremiumAnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _displayValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _animation.addListener(_updateValue);
    if (widget.autoAnimate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(PremiumAnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetValue != widget.targetValue) {
      _controller.reset();
      _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
      _animation.addListener(_updateValue);
      _controller.forward();
    }
  }

  void _updateValue() {
    setState(() {
      _displayValue = _animation.value * widget.targetValue;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _formattedValue {
    if (widget.showDecimal) {
      return '${widget.prefix}${_displayValue.toStringAsFixed(2)}${widget.suffix}';
    }
    return '${widget.prefix}${_displayValue.toInt().toString()}${widget.suffix}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formattedValue,
      style: widget.style,
    );
  }
}

/// Counter widget with comma formatting (e.g. ৳1,25,000)
class PremiumFormattedCounter extends StatefulWidget {
  final double targetValue;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final Duration duration;

  const PremiumFormattedCounter({
    super.key,
    required this.targetValue,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<PremiumFormattedCounter> createState() =>
      _PremiumFormattedCounterState();
}

class _PremiumFormattedCounterState extends State<PremiumFormattedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _displayValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: PremiumCurves.emphasized);
    _animation.addListener(_updateValue);
    _controller.forward();
  }

  @override
  void didUpdateWidget(PremiumFormattedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetValue != widget.targetValue) {
      _controller.reset();
      _controller.forward();
    }
  }

  void _updateValue() {
    setState(() {
      _displayValue = (_animation.value * widget.targetValue).toInt();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _formatted {
    final s = _displayValue.toString();
    final buf = StringBuffer(widget.prefix);
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    buf.write(widget.suffix);
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_formatted, style: widget.style);
  }
}

/// Animated success checkmark
class PremiumSuccessAnimation extends StatefulWidget {
  final double size;
  final Color color;

  const PremiumSuccessAnimation({
    super.key,
    this.size = 80,
    this.color = PremiumColors.success,
  });

  @override
  State<PremiumSuccessAnimation> createState() =>
      _PremiumSuccessAnimationState();
}

class _PremiumSuccessAnimationState extends State<PremiumSuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _checkAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: PremiumCurves.springSubtle),
    );
    _checkAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: PremiumCurves.emphasized),
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
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.5 + (0.5 * _scaleAnim.value),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: _CheckPainter(
                progress: _checkAnim.value,
                color: widget.color,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final center = size.width / 2;
    final startX = center - size.width * 0.2;
    final startY = center;
    final midX = center - size.width * 0.05;
    final midY = center + size.width * 0.15;
    final endX = center + size.width * 0.25;
    final endY = center - size.width * 0.1;

    if (progress < 0.5) {
      final t = progress * 2;
      path.moveTo(startX, startY);
      path.lineTo(
        startX + (midX - startX) * t,
        startY + (midY - startY) * t,
      );
    } else {
      final t = (progress - 0.5) * 2;
      path.moveTo(startX, startY);
      path.lineTo(midX, midY);
      path.moveTo(midX, midY);
      path.lineTo(
        midX + (endX - midX) * t,
        midY + (endY - midY) * t,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.progress != progress;
}
