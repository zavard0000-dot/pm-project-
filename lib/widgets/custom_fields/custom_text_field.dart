import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.title = null,
    required this.hint,
    this.maxLength = null,
    this.maxLines = 1,
    this.prefixIcon = null,
    this.isPassword = false,
    this.controller = null,
    this.error = null,
    this.onChanged = null,
  });

  final String? title;
  final String hint;
  final int? maxLength;
  final int maxLines;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? error;
  final ValueChanged<String>? onChanged;

  @override
  State<CustomTextField> createState() => _CustomeTextFieldState();
}

class _CustomeTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Container(
            child: Text(widget.title!, style: AppTextStyles.labelLarge),
            margin: EdgeInsets.only(bottom: 8),
          ),
        Container(
          //внешний отсут чье значение зависит от наличие ошибки у поле
          margin: EdgeInsets.only(bottom: widget.error != null ? 6 : 24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.hint,
              prefixIcon: (widget.prefixIcon == null
                  ? null
                  : Icon(
                      widget.prefixIcon,
                      color: AppColors.textSecondary,
                      size: 20,
                    )),
              suffixIcon: widget.isPassword == false
                  ? null
                  : IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () => (setState(() {
                        _obscureText = !_obscureText;
                      })),
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),

        //текст с ошибкой если есть
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(widget.error!, style: AppTextStyles.errorText),
          ),
      ],
    );
  }
}
