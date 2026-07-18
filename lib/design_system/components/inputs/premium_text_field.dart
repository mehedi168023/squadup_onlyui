import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/premium_colors.dart';
import '../../tokens/premium_typography.dart';
import '../../tokens/premium_spacing.dart';
import '../../tokens/premium_radius.dart';

/// Premium text field component with Samsung One UI-inspired design
/// Enhanced input with smooth animations and premium styling
class PremiumTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  
  const PremiumTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasError = widget.errorText != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PremiumRadius.input),
            border: Border.all(
              color: hasError
                  ? PremiumColors.danger
                  : _isFocused
                      ? PremiumColors.primary
                      : (isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder),
              width: _isFocused ? 2 : 1,
            ),
            color: isDark ? PremiumColors.darkSurface2 : PremiumColors.lightSurface1,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            autofocus: widget.autofocus,
            textCapitalization: widget.textCapitalization,
            style: PremiumTypography.body.copyWith(
              color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: PremiumSpacing.input,
              counterText: '',
            ),
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
          ),
        ),
        if (widget.helperText != null || widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              widget.errorText ?? widget.helperText!,
              style: PremiumTypography.caption.copyWith(
                color: hasError
                    ? PremiumColors.danger
                    : (isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary),
              ),
            ),
          ),
      ],
    );
  }
}

/// Premium search field with search icon and clear button
class PremiumSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autofocus;
  
  const PremiumSearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
    this.autofocus = false,
  });

  @override
  State<PremiumSearchField> createState() => _PremiumSearchFieldState();
}

class _PremiumSearchFieldState extends State<PremiumSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChange);
    }
    super.dispose();
  }

  void _onTextChange() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumTextField(
      controller: _controller,
      hint: widget.hint ?? 'Search...',
      autofocus: widget.autofocus,
      prefixIcon: Icon(
        Icons.search_rounded,
        color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
      ),
      suffixIcon: _hasText
          ? IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
              ),
              onPressed: _onClear,
            )
          : null,
      onChanged: widget.onChanged,
    );
  }
}

/// Premium password field with visibility toggle
class PremiumPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  
  const PremiumPasswordField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  State<PremiumPasswordField> createState() => _PremiumPasswordFieldState();
}

class _PremiumPasswordFieldState extends State<PremiumPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      obscureText: _obscureText,
      autofocus: widget.autofocus,
      prefixIcon: Icon(
        Icons.lock_rounded,
        color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded,
          color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
        ),
        onPressed: _toggleVisibility,
      ),
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
    );
  }
}
