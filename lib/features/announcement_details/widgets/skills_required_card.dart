import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class SkillsRequiredCard extends StatelessWidget {
  final List<String> skills;

  const SkillsRequiredCard({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (skills.isEmpty) {
      return SizedBox.shrink();
    }

    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💼 Требуемые навыки и технологии',
            style: AppTextStyles.headingMedium.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkSurfaceVariant.withOpacity(0.5)
                          : AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode
                            ? AppColors.primaryBlue.withOpacity(0.4)
                            : AppColors.primaryBlue.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      skill,
                      style: AppTextStyles.tag.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.primaryBlue,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
