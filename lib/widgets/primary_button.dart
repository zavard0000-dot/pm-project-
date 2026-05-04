import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.color,
    this.textColor,
  });
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: !isEnabled
            ? (isDarkMode
                  ? AppColors.darkSurfaceVariant
                  : AppColors.disabledGrey.withOpacity(0.2))
            : color,
        gradient: (isEnabled && color == null)
            ? const LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryPurple],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: (isEnabled && color == null)
            ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isEnabled ? onPressed : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ] else if (icon != null) ...[
                Icon(
                  icon,
                  color:
                      textColor ?? (isEnabled ? Colors.white : Colors.white60),
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                isLoading ? "Saving..." : text,
                style: AppTextStyles.button.copyWith(
                  color:
                      textColor ?? (isEnabled ? Colors.white : Colors.white60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
