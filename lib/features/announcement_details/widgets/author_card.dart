import 'package:flutter/material.dart';
import 'package:teamup/models/announcement.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class AuthorCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback? onTap;

  const AuthorCard({required this.announcement, this.onTap});

  String _getTimeAgo(DateTime? date) {
    if (date == null) return 'while ago';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${difference.inDays ~/ 7}w ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: BaseCard(
        child: Row(
          children: [
            UserAvatar(
              username: announcement.userName,
              avatarLink: announcement.userAvatarLink,
              radius: 29,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.userName ?? 'Unknown user',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (announcement.userUniversity != null ||
                      announcement.userCourse != null)
                    Text(
                      '${announcement.userUniversity ?? ''}'
                      '${announcement.userCourse != null ? ', ${announcement.userCourse} year' : ''}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    'posted ${_getTimeAgo(announcement.createdAt)}',
                    style: AppTextStyles.captionMedium.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
