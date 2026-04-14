import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamup/features/home/tabs/profile_tab/widgets/widgets.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/telegram_btn.dart';

class ProfileScreen extends StatelessWidget {
  final bool isCurrentUser;
  final String? userTelegramLink;

  const ProfileScreen({
    super.key,
    this.isCurrentUser = true,
    this.userTelegramLink,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;

        if (user == null) {
          return Scaffold(
            body: Center(
              child: Text('User not found', style: AppTextStyles.headingMedium),
            ),
          );
        }

        return Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Profile Header - Universal for both current user and other users
              ProfileHeader(user: user, isCurrentUser: isCurrentUser),

              const SizedBox(height: 60),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // About Myself Section
                    if (user.aboutMySelf.isNotEmpty)
                      AboutMyselfCard(content: user.aboutMySelf),
                    if (user.aboutMySelf.isNotEmpty) const SizedBox(height: 16),

                    // Contacts Section
                    ContactsCard(
                      email: user.email,
                      github: user.github,
                      linkedin: user.linkedin,
                      location: user.location,
                    ),
                    const SizedBox(height: 16),

                    // Location Section
                    if (user.location.isNotEmpty)
                      LocationCard(location: user.location),
                    if (user.location.isNotEmpty) const SizedBox(height: 16),

                    // Hard Skills Section
                    if (user.hardSkills.isNotEmpty)
                      HardSkillsCard(skills: user.hardSkills),
                    if (user.hardSkills.isNotEmpty) const SizedBox(height: 16),

                    // Current Projects Section
                    if (isCurrentUser)
                      Builder(
                        builder: (context) {
                          final isDarkMode =
                              Theme.of(context).brightness == Brightness.dark;
                          return Text(
                            '📁 Current Projects',
                            style: isDarkMode
                                ? AppTextStyles.darkHeadingSmall
                                : AppTextStyles.headingSmall,
                          );
                        },
                      ),
                    if (isCurrentUser) const SizedBox(height: 12),
                    if (isCurrentUser)
                      ...user.currentProjects.map((currentProject) {
                        return Column(children: [const SizedBox(height: 8)]);
                      }),

                    // Telegram contact button if not current user
                    if (!isCurrentUser) ...[
                      TelegramBtn(telegramLink: userTelegramLink),
                    ],

                    // Bottom padding for comfortable scrolling
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
