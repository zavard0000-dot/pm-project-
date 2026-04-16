import 'package:flutter/material.dart';
import 'package:teamup/models/models.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/telegram_btn.dart';
import 'package:teamup/features/profile/widgets/widgets.dart';

class UserProfileScreen extends StatelessWidget {
  final MyUser user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? AppColors.darkBackground
        : AppColors.background;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Profile Header with Close button (no edit/settings)
          ProfileHeader(
            user: user,
            isCurrentUser: false,
            showEditAndSettings: false,
          ),

          const SizedBox(height: 60),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // About Myself Section
                if (user.aboutMySelf.isNotEmpty) ...[
                  AboutMyselfCard(content: user.aboutMySelf),
                  const SizedBox(height: 16),
                ],

                // Contacts Section
                if (user.email.isNotEmpty ||
                    user.github.isNotEmpty ||
                    user.linkedin.isNotEmpty ||
                    user.location.isNotEmpty) ...[
                  ContactsCard(
                    email: user.email,
                    github: user.github,
                    linkedin: user.linkedin,
                    location: user.location,
                  ),
                  const SizedBox(height: 16),
                ],

                // Hard Skills Section
                if (user.hardSkills.isNotEmpty) ...[
                  HardSkillsCard(skills: user.hardSkills),
                  const SizedBox(height: 16),
                ],

                // Contact Telegram Button
                TelegramBtn(telegramLink: user.telegram),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
