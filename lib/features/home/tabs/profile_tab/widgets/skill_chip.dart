import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class SkillChip extends StatelessWidget {
  const SkillChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: isDarkMode ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: isDarkMode ? AppColors.primaryBlue : AppColors.primaryBlue,
        ),
      ),
    );
  }
}
