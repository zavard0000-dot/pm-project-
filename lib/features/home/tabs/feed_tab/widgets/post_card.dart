import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teamup/models/announcement.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class PostCard extends StatelessWidget {
  final Announcement announcement;
  final bool isFavorite;
  final Future<void> Function()? onFavoriteToggle;

  const PostCard({
    Key? key,
    required this.announcement,
    this.isFavorite = false,
    this.onFavoriteToggle,
  }) : super(key: key);

  String _getTypeLabel(String type) {
    switch (type) {
      case 'project':
        return '📌 Проект';
      case 'team':
        return '👥 Команда';
      case 'person':
        return '👤 Персона';
      default:
        return '';
    }
  }

  String _formatDeadline(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return 'Истёк';
    } else if (difference.inDays > 30) {
      return '📅 ${date.day}.${date.month}.${date.year}';
    } else if (difference.inDays > 0) {
      return '⏱ ${difference.inDays} дней';
    } else if (difference.inHours > 0) {
      return '⏰ ${difference.inHours}ч';
    } else {
      return '🔴 Сегодня';
    }
  }

  bool _isDeadlineSoon(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final difference = date.difference(now);
    return difference.inDays <= 7;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.go(
          '/home/announcement/${announcement.id ?? "1"}',
          extra: announcement,
        );
      },
      child: BaseCard(
        margin: EdgeInsets.all(16).copyWith(top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(
                  username: announcement.userName,
                  avatarLink: announcement.userAvatarLink,
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.userName ?? 'Unknown',
                        style: isDarkMode
                            ? AppTextStyles.darkBodyLarge
                            : AppTextStyles.subtitle,
                      ),
                      Text(
                        announcement.userUniversity ?? announcement.university,
                        style: isDarkMode
                            ? AppTextStyles.darkCaptionMedium
                            : AppTextStyles.captionMedium,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onFavoriteToggle != null
                      ? () async {
                          try {
                            await onFavoriteToggle!();
                          } catch (e) {
                            print('Error toggling favorite: $e');
                          }
                        }
                      : null,
                  child: Icon(
                    isFavorite ? Icons.star : Icons.star_outline,
                    color: isFavorite ? Colors.amber : Colors.grey,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('⚡ ', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(
                    announcement.title,
                    style: isDarkMode
                        ? AppTextStyles.darkHeadingSmall
                        : AppTextStyles.headingSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              announcement.description,
              style: isDarkMode
                  ? AppTextStyles.darkBodyMedium
                  : AppTextStyles.captionLarge,
            ),
            const SizedBox(height: 12),
            // Info badges - Type, Event Type, Deadline
            if (announcement.type.isNotEmpty ||
                announcement.eventType.isNotEmpty ||
                announcement.eventDateEnd != null)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Announcement Type Badge
                  if (announcement.type.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withValues(
                          alpha: isDarkMode ? 0.25 : 0.12,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primaryPurple.withValues(
                            alpha: isDarkMode ? 0.4 : 0.2,
                          ),
                        ),
                      ),
                      child: Text(
                        _getTypeLabel(announcement.type),
                        style:
                            (isDarkMode
                                    ? AppTextStyles.darkBodyMedium
                                    : AppTextStyles.bodySmall)
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? AppColors.darkTextPrimary
                                      : AppColors.primaryPurple,
                                ),
                      ),
                    ),
                  // Event Type Badge
                  if (announcement.eventType.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(
                          alpha: isDarkMode ? 0.25 : 0.12,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primaryBlue.withValues(
                            alpha: isDarkMode ? 0.4 : 0.2,
                          ),
                        ),
                      ),
                      child: Text(
                        '🎯 ${announcement.eventType}',
                        style:
                            (isDarkMode
                                    ? AppTextStyles.darkBodyMedium
                                    : AppTextStyles.bodySmall)
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? AppColors.darkTextPrimary
                                      : AppColors.primaryBlue,
                                ),
                      ),
                    ),
                  // Deadline Badge
                  if (announcement.eventDateEnd != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _isDeadlineSoon(announcement.eventDateEnd)
                            ? AppColors.accentPink.withValues(
                                alpha: isDarkMode ? 0.25 : 0.12,
                              )
                            : AppColors.accentPink.withValues(
                                alpha: isDarkMode ? 0.15 : 0.08,
                              ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.accentPink.withValues(
                            alpha: isDarkMode ? 0.4 : 0.2,
                          ),
                        ),
                      ),
                      child: Text(
                        _formatDeadline(announcement.eventDateEnd),
                        style:
                            (isDarkMode
                                    ? AppTextStyles.darkBodyMedium
                                    : AppTextStyles.bodySmall)
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? AppColors.darkTextPrimary
                                      : AppColors.accentPink,
                                ),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: announcement.requiredSkills
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(
                          alpha: isDarkMode ? 0.2 : 0.1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: isDarkMode
                            ? AppTextStyles.darkBodyMedium
                            : AppTextStyles.tag,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            TelegramBtn(telegramLink: announcement.telegramLink),
          ],
        ),
      ),
    );
  }
}
