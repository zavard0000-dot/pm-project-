import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamup/features/edit_profile/views/edit_profile_screen.dart';
import 'package:teamup/features/settings/widgets/widgets.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool messagesNotifications = false;
  late bool isDarkTheme;

  @override
  void initState() {
    super.initState();
    isDarkTheme = themeNotifier.value == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Gradient Header with Profile
          Consumer<MyAuthProvider>(
            builder: (context, authProvider, child) {
              final currentUser = authProvider.currentUser;

              return Container(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 20,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: (isDarkMode
                        ? [
                            Color.fromARGB(255, 23, 62, 148),
                            Color.fromARGB(255, 81, 37, 156),
                            Color.fromARGB(255, 113, 18, 61),
                          ]
                        : [
                            Color(0xFF2563EB),
                            Color(0xFF7C3AED),
                            Color(0xFFDB2777),
                          ]),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Back button and title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            'Настройки',
                            style: AppTextStyles.appBarTitle,
                          ),
                          SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Profile info
                      currentUser != null
                          ? Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundImage: NetworkImage(
                                      currentUser.avatarLink,
                                    ),
                                    onBackgroundImageError:
                                        (exception, stackTrace) {},
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentUser.fullName,
                                          style: AppTextStyles.whiteBodyLarge,
                                        ),
                                        Text(
                                          currentUser.username,
                                          style: AppTextStyles.whiteSubtle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'User not found',
                                  style: AppTextStyles.whiteBodyLarge,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          // Settings content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Profile Section
                SettingSection(
                  title: '👤 Профиль',
                  children: [
                    SettingMenuItem(
                      icon: Icons.person_outline,
                      label: 'Редактировать профиль',
                      iconColor: Color(0xFF7C3AED),
                      onTap: () {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Редактирование профиля')),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    SettingMenuItem(
                      icon: Icons.lock_outline,
                      label: 'Настройки аккаунта',
                      iconColor: Color(0xFF7C3AED),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Настройки аккаунта')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Notifications Section
                SettingSection(
                  title: '🔔 Уведомления',
                  children: [
                    SettingMenuItem(
                      icon: Icons.notifications_outlined,
                      label: 'Push-уведомления',
                      iconColor: Color(0xFF7C3AED),
                      trailing: Switch(
                        value: pushNotifications,
                        onChanged: (value) {
                          setState(() => pushNotifications = value);
                        },
                        activeColor: Color(0xFF111827),
                      ),
                    ),
                    SettingMenuItem(
                      icon: Icons.mail_outline,
                      label: 'Email уведомления',
                      iconColor: Color(0xFF7C3AED),
                      trailing: Switch(
                        value: emailNotifications,
                        onChanged: (value) {
                          setState(() => emailNotifications = value);
                        },
                        activeColor: Color(0xFF111827),
                      ),
                    ),
                    SettingMenuItem(
                      icon: Icons.message_outlined,
                      label: 'Сообщения',
                      iconColor: Color(0xFF7C3AED),
                      trailing: Switch(
                        value: messagesNotifications,
                        onChanged: (value) {
                          setState(() => messagesNotifications = value);
                        },
                        activeColor: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Preferences Section
                SettingSection(
                  title: '⚙️ Предпочтения',
                  children: [
                    SettingMenuItem(
                      icon: Icons.language_outlined,
                      label: 'Язык',
                      iconColor: Color(0xFF10B981),
                      onTap: () {
                        print('[SETTINGS] Language selection tapped');
                      },
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Русский', style: AppTextStyles.captionMedium),
                        ],
                      ),
                    ),
                    SettingMenuItem(
                      icon: Icons.brightness_4_outlined,
                      label: 'Темная тема',
                      iconColor: Color(0xFF00B4D8),
                      trailing: Switch(
                        value: isDarkTheme,
                        onChanged: (value) {
                          setState(() {
                            isDarkTheme = value;
                          });
                          themeNotifier.value = value
                              ? ThemeMode.dark
                              : ThemeMode.light;
                          print('[SETTINGS] Dark theme toggled: $value');
                        },
                        activeColor: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Support Section
                SettingSection(
                  title: '🤝 Поддержка',
                  children: [
                    SettingMenuItem(
                      icon: Icons.help_outline,
                      label: 'Помощь и ФАО',
                      iconColor: Color(0xFFFF8C42),
                      onTap: () {
                        print('[SETTINGS] Help and FAQ tapped');
                      },
                    ),
                    SettingMenuItem(
                      icon: Icons.description_outlined,
                      label: 'Условия использования',
                      iconColor: Color(0xFFFF8C42),
                      onTap: () {
                        print('[SETTINGS] Terms of use tapped');
                      },
                    ),
                    SettingMenuItem(
                      icon: Icons.info_outline,
                      label: 'О приложении',
                      iconColor: Color(0xFFFF8C42),
                      onTap: () {
                        print('[SETTINGS] About app tapped');
                      },
                    ),
                    SettingMenuItem(
                      icon: Icons.share_outlined,
                      label: 'Поделиться приложением',
                      iconColor: Color(0xFFFF8C42),
                      onTap: () {
                        print('[SETTINGS] Share app tapped');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Logout Button
                GestureDetector(
                  onTap: () {
                    print('[AUTH] User logged out');
                    context.read<MyAuthProvider>().signOut();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.errorRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.errorRed.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: AppColors.errorRed, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Вывести из аккаунта',
                          style: AppTextStyles.errorText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Version info
                Center(
                  child: Column(
                    children: [
                      Text('Версия 1.0.0', style: AppTextStyles.captionMedium),
                      Text(
                        '© 2026 TeamFinder',
                        style: AppTextStyles.captionMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
