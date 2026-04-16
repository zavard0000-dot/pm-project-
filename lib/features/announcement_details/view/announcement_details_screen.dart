import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teamup/models/models.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/telegram_btn.dart';
import 'package:teamup/widgets/round_icon_btn.dart';
import '../widgets/widgets.dart';

class AnnouncementDetailsScreen extends StatelessWidget {
  final String announcementId;
  final Announcement? announcement;

  const AnnouncementDetailsScreen({
    super.key,
    required this.announcementId,
    this.announcement,
  });

  void _showAuthorProfile(BuildContext context) {
    print(
      '[AnnouncementDetailsScreen] Opening author profile for: ${announcement?.userName}',
    );
    print('[AnnouncementDetailsScreen] Author ID: ${announcement?.userId}');
    print(
      '[AnnouncementDetailsScreen] Telegram: ${announcement?.telegramLink}',
    );

    context.go(
      '/home/user/${announcement?.userId}',
      extra: announcement?.telegramLink,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (announcement == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? AppColors.darkBackground
        : AppColors.background;

    final gradientColors = isDarkMode
        ? [Color.fromARGB(255, 23, 62, 148), Color.fromARGB(255, 81, 37, 156)]
        : [AppColors.primaryBlue, AppColors.primaryPurple];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header with title and description
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      roundIconBtn(
                        icon: Icons.arrow_back,
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        announcement!.title,
                        style: AppTextStyles.whiteHeadingLarge.copyWith(
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        announcement!.description,
                        style: AppTextStyles.whiteCaption.copyWith(height: 1.4),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Details cards
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    AuthorCard(
                      announcement: announcement!,
                      onTap: () => _showAuthorProfile(context),
                    ),
                    const SizedBox(height: 14),
                    EventDetailsCard(announcement: announcement!),
                    const SizedBox(height: 14),
                    DescriptionCard(announcement: announcement!),
                    if (announcement!.requiredSkills.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      SkillsRequiredCard(skills: announcement!.requiredSkills),
                    ],
                    const SizedBox(height: 24),
                    TelegramBtn(telegramLink: announcement!.telegramLink),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class _Dot extends StatelessWidget {
//   const _Dot({this.isFilled = false});

//   final bool isFilled;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 20,
//       height: 12,
//       decoration: BoxDecoration(
//         color: isFilled ? Colors.white : Colors.transparent,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white, width: 2),
//       ),
//     );
//   }
// }
