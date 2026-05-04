import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamup/features/home/tabs/profile_tab/widgets/widgets.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:teamup/models/models.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/telegram_btn.dart';

class ProfileScreen extends StatelessWidget {
  final bool isCurrentUser;
  final String? userTelegramLink;
  final String? userId;

  const ProfileScreen({
    super.key,
    this.isCurrentUser = true,
    this.userTelegramLink,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCurrentUser && userId != null) {
      // Загружаем профиль другого пользователя через провайдер
      return FutureBuilder<MyUser?>(
        future: context.read<MyAuthProvider>().loadUserById(userId: userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          final user = snapshot.data;
          if (user == null) {
            return Scaffold(
              body: Center(
                child: Text(
                  'User not found',
                  style: AppTextStyles.headingMedium,
                ),
              ),
            );
          }

          return _buildProfileContent(user, context);
        },
      );
    }

    // Показываем текущего пользователя
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

        return _buildProfileContent(user, context);
      },
    );
  }

  Widget _buildProfileContent(MyUser user, BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Profile Header
          ProfileHeader(user: user, isCurrentUser: isCurrentUser),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // About Myself Section
                AboutMyselfCard(content: user.aboutMySelf),
                const SizedBox(height: 16),

                // Contacts Section
                ContactsCard(
                  email: user.email,
                  github: user.github,
                  linkedin: user.linkedin,
                  location: user.location,
                ),
                const SizedBox(height: 16),

                // Location Section
                LocationCard(location: user.location),
                const SizedBox(height: 16),

                // Hard Skills Section
                HardSkillsCard(skills: user.hardSkills),
                const SizedBox(height: 16),

                // Current Projects Section (only for current user)
                if (isCurrentUser) ...[
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
                  const SizedBox(height: 12),
                  ...user.currentProjects.map((currentProject) {
                    return Column(
                      children: [
                        // CurrentProjectCard(
                        //   title: currentProject.title,
                        //   subtitle: currentProject.subtitle,
                        // ),
                        SizedBox(height: 8),
                      ],
                    );
                  }),
                ],

                // Telegram button (only for other user)
                if (!isCurrentUser) ...[
                  const SizedBox(height: 16),
                  TelegramBtn(telegramLink: userTelegramLink),
                ],

                // Большой отступ внизу для удобного скролла над BottomNavigationBar (only for current user)
                if (isCurrentUser) ...[
                  const SizedBox(height: 100),
                ] else ...[
                  const SizedBox(height: 32),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
