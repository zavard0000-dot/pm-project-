import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamup/features/profile/widgets/widgets.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:teamup/theme.dart';

class MyProfileTab extends StatelessWidget {
  const MyProfileTab({super.key});

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
              // Profile Header with Edit and Settings buttons
              ProfileHeader(
                user: user,
                isCurrentUser: true,
                showEditAndSettings: true,
              ),

              const SizedBox(height: 60),

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

                    // Hard Skills Section
                    HardSkillsCard(skills: user.hardSkills),
                    const SizedBox(height: 16),

                    // Current Projects Section
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
                    const SizedBox(height: 12),
                    if (user.currentProjects.isEmpty)
                      Builder(
                        builder: (context) {
                          final isDarkMode =
                              Theme.of(context).brightness == Brightness.dark;
                          return Text(
                            'No active projects',
                            style: isDarkMode
                                ? AppTextStyles.darkCaptionMedium
                                : AppTextStyles.captionMedium,
                          );
                        },
                      ),
                    ...user.currentProjects.map((project) {
                      return Column(
                        children: [
                          // Project card can be added here
                          const SizedBox(height: 8),
                        ],
                      );
                    }),

                    // Bottom padding for comfortable scrolling over BottomNavigationBar
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
