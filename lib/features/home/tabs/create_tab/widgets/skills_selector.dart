import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class SkillsSelector extends StatelessWidget {
  final List<String> selectedSkills;
  final ValueChanged<List<String>> onSkillsChanged;
  final List<String> availableSkills;
  final int maxSkills;

  const SkillsSelector({
    super.key,
    required this.selectedSkills,
    required this.onSkillsChanged,
    required this.availableSkills,
    this.maxSkills = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Skills and technologies',
              style: AppTextStyles.labelLarge.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            Text(
              '${selectedSkills.length}/$maxSkills',
              style: AppTextStyles.captionMedium.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableSkills.map((skill) {
            final isSelected = selectedSkills.contains(skill);
            final isDisabled =
                !isSelected && selectedSkills.length >= maxSkills;

            return GestureDetector(
              onTap: isDisabled
                  ? null
                  : () {
                      final newSkills = [...selectedSkills];
                      if (isSelected) {
                        newSkills.remove(skill);
                      } else {
                        newSkills.add(skill);
                      }
                      onSkillsChanged(newSkills);
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDarkMode
                            ? AppColors.darkBlue
                            : AppColors.primaryBlue)
                      : isDisabled
                      ? isDarkMode
                            ? AppColors.darkInputBorder
                            : AppColors.inputBorder
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? (isDarkMode
                              ? AppColors.darkBlue
                              : AppColors.primaryBlue)
                        : isDisabled
                        ? isDarkMode
                              ? AppColors.darkInputBorder
                              : AppColors.inputBorder
                        : isDarkMode
                        ? AppColors.darkInputBorder
                        : AppColors.inputBorder,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  skill,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSelected
                        ? Colors.white
                        : isDisabled
                        ? AppColors.disabledGrey
                        : isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
