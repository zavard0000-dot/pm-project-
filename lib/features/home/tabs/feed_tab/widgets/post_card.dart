import 'package:flutter/material.dart';
import 'package:teamup/features/announcement_details/view/view.dart';
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
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => AnnouncementDetailsScreen()));
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
                      ? AppColors.primaryPurple.withOpacity(0.7)
                      : Colors.grey[300],
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        university,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
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
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
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
