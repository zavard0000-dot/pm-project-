import 'package:flutter/material.dart';
import 'package:teamup/models/announcement.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class DescriptionCard extends StatelessWidget {
  final Announcement announcement;

  const DescriptionCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Полное описание',
            style: AppTextStyles.headingMedium.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            announcement.description,
            style: AppTextStyles.captionLarge.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextPrimary.withOpacity(0.85)
                  : AppColors.textPrimary,
              height: 1.6,
            ),
          ),
          // Show university if different from author's university
          if (announcement.university.isNotEmpty &&
              announcement.university != announcement.userUniversity) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(
                  alpha: isDarkMode ? 0.15 : 0.1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Университет: ${announcement.university}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Show event type if available
          if (announcement.eventType.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accentPink.withValues(
                  alpha: isDarkMode ? 0.15 : 0.1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark_outline,
                    size: 16,
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.accentPink,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Тип события: ${announcement.eventType}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Show required team size if available
          if (announcement.requiredTeamSize != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(
                  alpha: isDarkMode ? 0.15 : 0.1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.group,
                    size: 16,
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.primaryPurple,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Требуемый размер команды: ${announcement.requiredTeamSize} человек',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
