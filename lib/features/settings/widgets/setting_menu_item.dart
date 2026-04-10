import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class SettingMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const SettingMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0),
        child: Row(
          children: [
            Icon(icon, size: 24, color: iconColor ?? Color(0xFF7C3AED)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: isDarkMode
                    ? AppTextStyles.darkBodyLarge
                    : AppTextStyles.bodyLarge,
              ),
            ),
            if (trailing != null)
              trailing!
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : Color(0xFF9CA3AF),
              ),
          ],
        ),
      ),
    );
  }
}
