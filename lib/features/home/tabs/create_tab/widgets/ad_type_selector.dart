import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class AdTypeSelector extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String> onTypeChanged;

  const AdTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Ad type',
              style: AppTextStyles.labelLarge.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            Text(
              ' *',
              style: AppTextStyles.labelLarge.copyWith(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            // First row: project and team
            Row(
              children: [
                Expanded(
                  child: _AdTypeButton(
                    icon: Icons.folder,
                    label: 'Project',
                    isSelected: selectedType == 'project',
                    onTap: () => onTypeChanged('project'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AdTypeButton(
                    icon: Icons.people,
                    label: 'Team',
                    isSelected: selectedType == 'team',
                    onTap: () => onTypeChanged('team'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Second row: person
            Row(
              children: [
                Expanded(
                  child: _AdTypeButton(
                    icon: Icons.person,
                    label: 'Person',
                    isSelected: selectedType == 'person',
                    onTap: () => onTypeChanged('person'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Container()),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _AdTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AdTypeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.primaryPurple
                : isDarkMode
                ? AppColors.darkInputBorder
                : AppColors.inputBorder,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? AppColors.primaryPurple.withOpacity(0.08)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primaryPurple
                    : isDarkMode
                    ? AppColors.darkSurface
                    : AppColors.surface,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryPurple
                      : isDarkMode
                      ? AppColors.darkInputBorder
                      : AppColors.inputBorder,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected
                    ? AppColors.primaryPurple
                    : isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
