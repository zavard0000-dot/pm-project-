import 'package:flutter/material.dart';
import 'package:teamup/features/home/tabs/profile_tab/widgets/widgets.dart';
// import 'package:teamup/theme.dart';
import 'package:teamup/models/models.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  //final my_user user;

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
      sections: [
        ProfileSectionModel(
          title: '📝 about myself',
          content:
              "A passionate developer and designer. I love creating cool web apps and participating in hackathons. I'm looking for interesting projects and a team to bring innovative ideas to life.",
        ),
        ProfileSectionModel(
          title: '📇 Contacts',
          content:
              "Telegram: @aigerim_dev\nEmail: hello@aigerim.dev\nGitHub: github.com/aigerim",
        ),
      ],
      hardSkills: ['Flutter', 'Dart', 'ReactJS', 'Figma', 'Firebase'],
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
      // Используем ListView для плавного скролла всего экрана
      body: ListView(
        // Убираем дефолтные отступы, чтобы градиент был у самого края
        padding: EdgeInsets.zero,
        //physics: const BouncingScrollPhysics(), // Приятная анимация скролла
        children: [
          // Шапка с градиентом и карточками
          ProfileHeader(user: user),

          // Отступ после Stack, чтобы компенсировать Positioned карточки
          const SizedBox(height: 60),

          // Основной контент страницы (сделал больше, чтобы листалось)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Sections
                //... - вставляет элементы в тек коллекцию из списка/набора и др коллекций
                ...user.sections.map((section) {
                  return Column(
                    children: [
                      SectionCard(
                        title: section.title,
                        content: section.content,
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                }),
                // SectionCard(
                //   title: '📝 about myself',
                //   content:
                //       "A passionate developer and designer. I love creating cool web apps and participating in hackathons. I'm looking for interesting projects and a team to bring innovative ideas to life.",
                // ),
                // const SizedBox(height: 16),
                // SectionCard(
                //   title: '📇 Contacts',
                //   content:
                //       "Telegram: @aigerim_dev\nEmail: hello@aigerim.dev\nGitHub: github.com/aigerim",
                // ),
                // const SizedBox(height: 16),

                //hard skills (дополнительное поле)
                const Text(
                  'Hard Skills',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),
                if (user.hardSkills.isEmpty) Text("you have no hard skills!"),
                if (user.hardSkills.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.hardSkills
                        .map((skill) => SkillChip(label: skill))
                        .toList(),
                  ),
                const SizedBox(height: 24),

                //Текущие проекты (Дополнительная секция)
                const Text(
                  'Current Projects',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
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
