import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEnabled
              ? const [AppColors.primaryBlue, AppColors.primaryPurple]
              : [
                  AppColors.disabledGrey.withOpacity(0.5),
                  AppColors.disabledGrey.withOpacity(0.5),
                ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
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
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isEnabled ? Colors.white : Colors.white60,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: AppTextStyles.button.copyWith(
                  color: isEnabled ? Colors.white : Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
