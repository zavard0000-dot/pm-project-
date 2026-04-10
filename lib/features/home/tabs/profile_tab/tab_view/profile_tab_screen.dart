import 'package:flutter/material.dart';
import 'package:teamup/features/home/tabs/profile_tab/widgets/widgets.dart';
import 'package:teamup/models/models.dart';
import 'package:teamup/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MyUser(
      fullName: 'Айгерім Калиева',
      username: '@aigerim_dev',
      avatarLink: 'https://i.pravatar.cc/150?img=5',
      universityName: 'KBTU',
      currentCourse: 3,
      professionName: 'Computer Science',
      stats: [
        ProfileStatModel(
          icon: Icons.track_changes,
          value: 22,
          title: 'Projects',
          iconColor: Color(0xFF2563EB),
        ),
        ProfileStatModel(
          icon: Icons.people_outline,
          value: 111,
          title: 'Connections',
          iconColor: Color(0xFF7C3AED),
        ),
        ProfileStatModel(
          icon: Icons.emoji_events_outlined,
          value: 7,
          title: 'Achievements',
          iconColor: Color(0xFFDB2777),
        ),
      ],
      aboutMySelf:
          "A passionate developer and designer. I love creating cool web apps and participating in hackathons. I'm looking for interesting projects and a team to bring innovative ideas to life.",
      email: 'aigerim.k@kbtu.kz',
      github: '@aigerim_dev',
      linkedin: 'linkedin.com/in/aigerim-k',
      location: 'Almaty, Kazakhstan',
      hardSkills: [
        'React',
        '2D Design',
        'Docker',
        'Frontend',
        'Figma',
        'UI/UX Design',
        'Git',
        'PostgreSQL',
      ],
      currentProjects: [
        CurrentProjectModel(
          title: 'UniMatch App',
          subtitle: 'Mobile app for university students.',
        ),
        CurrentProjectModel(
          title: 'Digital Almaty Hackathon',
          subtitle: 'Building an MVP for city services.',
        ),
      ],
    );

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
                      CurrentProjectCard(
                        title: currentProject.title,
                        subtitle: currentProject.subtitle,
                      ),
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
  }
}
