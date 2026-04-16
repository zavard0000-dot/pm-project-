import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class AboutMyselfCard extends StatelessWidget {
  final String content;

  const AboutMyselfCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final displayContent = content.isEmpty
        ? 'Описание не указано. Добавьте информацию в настройках профиля.'
        : content;
    final isPlaceholder = content.isEmpty;

    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📝 Обо мне',
            style: isDarkMode
                ? AppTextStyles.darkHeadingSmall
                : AppTextStyles.headingSmall,
          ),
          const SizedBox(height: 12),
          Text(
            displayContent,
            style:
                (isDarkMode
                        ? AppTextStyles.darkBodyMedium
                        : AppTextStyles.captionLarge)
                    .copyWith(
                      color: isPlaceholder
                          ? (isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary)
                          : null,
                      fontStyle: isPlaceholder
                          ? FontStyle.italic
                          : FontStyle.normal,
                      height: 1.5,
                    ),
          ),
        ],
      ),
    );
  }
}
