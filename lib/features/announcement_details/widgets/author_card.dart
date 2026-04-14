import 'package:flutter/material.dart';
import 'package:teamup/models/announcement.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class AuthorCard extends StatelessWidget {
  final Announcement announcement;

  const AuthorCard({required this.announcement});

  String _getTimeAgo(DateTime? date) {
    if (date == null) return 'давно';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'только что';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}м назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}ч назад';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}д назад';
    } else {
      return '${difference.inDays ~/ 7}н назад';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BaseCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: announcement.userName != null
                ? Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryPurple.withValues(alpha: 0.7),
                    ),
                    child: Center(
                      child: Text(
                        (announcement.userName ?? 'A')[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 58,
                    height: 58,
                    color: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.userName ?? 'Неизвестный пользователь',
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
                    '${announcement.userCourse != null ? ', ${announcement.userCourse} курс' : ''}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  'опубликовано ${_getTimeAgo(announcement.createdAt)}',
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
    );
  }
}
