import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teamup/router.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';
import 'telegram_btn.dart';

class PostCard extends StatelessWidget {
  final String name;
  final String university;
  final String title;
  final String description;
  final List<String> tags;
  final bool isAvatarText;

  const PostCard({
    Key? key,
    required this.name,
    required this.university,
    required this.title,
    required this.description,
    required this.tags,
    this.isAvatarText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.go('/home/announcement/1');
      },
      child: BaseCard(
        margin: EdgeInsets.all(16).copyWith(top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isAvatarText
                      ? AppColors.primaryPurple.withValues(alpha: 0.7)
                      : (isDarkMode
                            ? AppColors.darkSurfaceVariant
                            : Colors.grey[300]!),
                  backgroundImage: !isAvatarText
                      ? const NetworkImage('https://i.pravatar.cc/150?img=5')
                      : null,
                  child: isAvatarText
                      ? Text(
                          name[0],
                          style: const TextStyle(color: Colors.white),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: isDarkMode
                            ? AppTextStyles.darkBodyLarge
                            : AppTextStyles.subtitle,
                      ),
                      Text(
                        university,
                        style: isDarkMode
                            ? AppTextStyles.darkCaptionMedium
                            : AppTextStyles.captionMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.star, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('⚡ ', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(
                    title,
                    style: isDarkMode
                        ? AppTextStyles.darkHeadingSmall
                        : AppTextStyles.headingSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: isDarkMode
                  ? AppTextStyles.darkBodyMedium
                  : AppTextStyles.captionLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
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
            TelegramBtn(),
            // SizedBox(height: 16),
            // PrimaryButton(text: "ASD", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
