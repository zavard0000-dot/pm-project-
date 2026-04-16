import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: isDarkMode ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(
            alpha: isDarkMode ? 0.4 : 0.3,
          ),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.tag.copyWith(
          color: isDarkMode ? AppColors.darkTextPrimary : AppColors.primaryBlue,
        ),
      ),
    );
  }
}
