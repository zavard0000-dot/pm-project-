import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: isDarkMode
                ? AppTextStyles.darkBodyLarge
                : AppTextStyles.statNumber,
          ),
          Text(
            label,
            style: isDarkMode
                ? AppTextStyles.darkCaptionMedium
                : AppTextStyles.statLabel,
          ),
        ],
      ),
    );
  }
}
