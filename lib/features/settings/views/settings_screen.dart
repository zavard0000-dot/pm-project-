import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teamup/router.dart';
import 'package:teamup/features/settings/widgets/widgets.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';
import 'package:teamup/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = settingsService.pushNotifications;
  bool emailNotifications = settingsService.emailNotifications;
  bool messagesNotifications = settingsService.messagesNotifications;
  late bool isDarkTheme;

  void _showNotImplemented() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is not implemented yet'),
        duration: Duration(seconds: 2),
      ),
    );
  }

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
              final currentUser = authProvider.user;

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
                            AppColors.primaryBlue,
                            AppColors.primaryPurple,
                            AppColors.accentPink,
                          ]),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                            'Settings',
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
                                  UserAvatar(
                                    username: currentUser.fullName,
                                    avatarLink: currentUser.avatarLink,
                                    radius: 32,
                                    showBorder: true,
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
                                          '@${currentUser.username}',
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
                  title: '👤 Profile',
                  children: [
                    SettingMenuItem(
                      icon: Icons.person_outline,
                      label: 'Edit Profile',
                      iconColor: Color(0xFF7C3AED),
                      onTap: () {
                        context.go(AppRoutes.editProfile);
                      },
                    ),
                    SettingMenuItem(
                      icon: Icons.lock_outline,
                      label: 'Account Settings',
                      iconColor: Color(0xFF7C3AED),
                      onTap: _showNotImplemented,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Notifications Section
                SettingSection(
                  title: '🔔 Notifications',
                  children: [
                    SettingMenuItem(
                      icon: Icons.notifications_outlined,
                      label: 'Push Notifications',
                      iconColor: Color(0xFF7C3AED),
                      trailing: Switch(
                        value: pushNotifications,
                        onChanged: (value) {
                          setState(() => pushNotifications = value);
                          settingsService.pushNotifications = value;
                        },
                        activeColor: Color(0xFF111827),
                      ),
                    ),
                    SettingMenuItem(
                      icon: Icons.mail_outline,
                      label: 'Email Notifications',
                      iconColor: Color(0xFF7C3AED),
                      trailing: Switch(
                        value: emailNotifications,
                        onChanged: (value) {
                          setState(() => emailNotifications = value);
                          settingsService.emailNotifications = value;
                        },
                        activeColor: Color(0xFF111827),
                      ),
                    ),
                    SettingMenuItem(
                      icon: Icons.message_outlined,
                      label: 'Messages',
                      iconColor: Color(0xFF7C3AED),
                      trailing: Switch(
                        value: messagesNotifications,
                        onChanged: (value) {
                          setState(() => messagesNotifications = value);
                          settingsService.messagesNotifications = value;
                        },
                        activeColor: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Preferences Section
                SettingSection(
                  title: '⚙️ Preferences',
                  children: [
                    /*
                    SettingMenuItem(
                      icon: Icons.language_outlined,
                      label: 'Language',
                      iconColor: Color(0xFF10B981),
                      onTap: () {
                        print('[SETTINGS] Language selection tapped');
                      },
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('English', style: AppTextStyles.captionMedium),
                        ],
                      ),
                    ),
                    */
                    SettingMenuItem(
                      icon: Icons.brightness_4_outlined,
                      label: 'Dark Theme',
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
                          settingsService.themeMode = value ? 'dark' : 'light';
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
                  title: '🤝 Support',
                  children: [
                    SettingMenuItem(
                      icon: Icons.help_outline,
                      label: 'Help & FAQ',
                      iconColor: Color(0xFFFF8C42),
                      onTap: _showNotImplemented,
                    ),
                    SettingMenuItem(
                      icon: Icons.description_outlined,
                      label: 'Terms of Use',
                      iconColor: Color(0xFFFF8C42),
                      onTap: _showNotImplemented,
                    ),
                    SettingMenuItem(
                      icon: Icons.info_outline,
                      label: 'About App',
                      iconColor: Color(0xFFFF8C42),
                      onTap: _showNotImplemented,
                    ),
                    SettingMenuItem(
                      icon: Icons.share_outlined,
                      label: 'Share App',
                      iconColor: Color(0xFFFF8C42),
                      onTap: _showNotImplemented,
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
                          'Log Out',
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
                      Text('Version 1.0.0', style: AppTextStyles.captionMedium),
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
