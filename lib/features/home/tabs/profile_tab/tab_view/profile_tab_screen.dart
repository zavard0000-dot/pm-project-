import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamup/features/home/tabs/profile_tab/widgets/widgets.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:teamup/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;

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
              // Profile Header
              ProfileHeader(user: user),

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

                    // Location Section
                    LocationCard(location: user.location),
                    const SizedBox(height: 16),

                    // Hard Skills Section
                    HardSkillsCard(skills: user.hardSkills),
                    const SizedBox(height: 16),

                    // Current Projects Section
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

                    // Большой отступ внизу для удобного скролла над BottomNavigationBar
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
