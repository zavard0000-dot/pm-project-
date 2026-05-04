import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamup/features/home/tabs/create_tab/tab_view/creat_tab_screen.dart';
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

        // Убедимся, что объявления загружены
        if (authProvider.myAnnouncements.isEmpty && user.uid.isNotEmpty) {
          Future.microtask(() => authProvider.loadMyAnnouncements());
        }

        return _buildProfileContent(user, context);
      },
    );
  }

  Widget _buildProfileContent(MyUser user, BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (isCurrentUser) {
            final authProvider = context.read<MyAuthProvider>();
            // Обновляем список своих объявлений
            await authProvider.loadMyAnnouncements();
            // Обновляем список ленты (опционально)
            await authProvider.loadAnnouncements();
          }
        },
        child: ListView(
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
                  // const SizedBox(height: 16),

                  // Current Projects Section (only for current user)
                  if (isCurrentUser) ...[
                    // Builder(
                    //   builder: (context) {
                    //     final isDarkMode =
                    //         Theme.of(context).brightness == Brightness.dark;
                    //     return Text(
                    //       '📁 Current Projects',
                    //       style: isDarkMode
                    //           ? AppTextStyles.darkHeadingSmall
                    //           : AppTextStyles.headingSmall,
                    //     );
                    //   },
                    // ),
                    // const SizedBox(height: 12),
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

                  // My Announcements Section (only for current user)
                  if (isCurrentUser) ...[
                    const SizedBox(height: 24),
                    _buildMyAnnouncements(context, user.uid),
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
      ),
    );
  }

  Widget _buildMyAnnouncements(BuildContext context, String userId) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final myAnnouncements = context.watch<MyAuthProvider>().myAnnouncements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📢 My Announcements',
          style: isDarkMode
              ? AppTextStyles.darkHeadingSmall
              : AppTextStyles.headingSmall,
        ),
        // const SizedBox(height: 12),
        if (myAnnouncements.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? AppColors.darkInputBorder
                    : AppColors.inputBorder,
              ),
            ),
            child: Text(
              'You haven\'t created any announcements yet',
              style: isDarkMode
                  ? AppTextStyles.darkBodyMedium
                  : AppTextStyles.bodyMedium,
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: myAnnouncements.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final announcement = myAnnouncements[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateTabScreen(announcementToEdit: announcement),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.darkSurfaceVariant
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.darkInputBorder
                          : AppColors.inputBorder,
                    ),
                    boxShadow: [
                      if (!isDarkMode)
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              announcement.title,
                              style:
                                  (isDarkMode
                                          ? AppTextStyles.darkBodyLarge
                                          : AppTextStyles.bodyLarge)
                                      .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Icon(Icons.edit_outlined, size: 20),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        announcement.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: isDarkMode
                            ? AppTextStyles.darkBodyMedium
                            : AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
