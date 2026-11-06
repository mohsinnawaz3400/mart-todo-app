
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;

  final IconData? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;

  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;

  final int maxLines;
  final int? maxLength;
  final int? minLines;

  final FocusNode? focusNode;

  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onTapOutside;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.minLines,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,

      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,

      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,

      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      maxLength: maxLength,

      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,

      onTapOutside: (_) {
        if (onTapOutside != null) {
          onTapOutside!();
        } else {
          FocusScope.of(context).unfocus();
        }
      },

      style: theme.textTheme.bodyMedium?.copyWith(
        color: colors.onSurface,
      ),

      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,

        prefixIcon: prefixIcon != null
            ? Icon(
          prefixIcon,
          size: 20,
          color: colors.primary,
        )
            : null,

        suffixIcon: suffixIcon,

        counterText: '',
        filled: true,

        fillColor: colors.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: colors.outlineVariant,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: colors.outlineVariant,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: colors.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: colors.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: colors.error,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
