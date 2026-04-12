// ==========================================
// 📂 screens/home/home_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:teamup/theme.dart';
import '../widgets/widgets.dart';

class FeedTabScreen extends StatefulWidget {
  const FeedTabScreen({Key? key}) : super(key: key);

  @override
  State<FeedTabScreen> createState() => _FeedTabScreenState();
}

class _FeedTabScreenState extends State<FeedTabScreen> {
  @override
  void initState() {
    super.initState();
    // Триггер #3: Инициализация страницы - загружаем объявления
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyAuthProvider>().loadAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MyAuthProvider>(
        builder: (context, authProvider, _) {
          // Триггер #2: Pull-to-refresh - обновляем объявления
          return RefreshIndicator(
            onRefresh: () => authProvider.loadAnnouncements(),
            child: _buildContent(authProvider, context),
          );
        },
      ),
    );
  }

  Widget _buildContent(MyAuthProvider authProvider, BuildContext context) {
    // Если объявления загружаются
    if (authProvider.isLoadingAnnouncements) {
      return CustomScrollView(
        slivers: [
          FeedHeader(),
          SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    // Если объявлений нет
    if (!authProvider.hasAnnouncements) {
      return CustomScrollView(
        slivers: [
          FeedHeader(),
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No announcements found',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try adjusting your filters',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Если есть объявления
    return CustomScrollView(
      slivers: [
        FeedHeader(),

        SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Feed Cards
        SliverList.builder(
          itemCount: authProvider.announcements.length,
          itemBuilder: (context, index) {
            final announcement = authProvider.announcements[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: PostCard(
                id: announcement.id,
                name: announcement.userName ?? 'Unknown',
                university:
                    '${announcement.userUniversity}, ${announcement.userCourse} year',
                title: announcement.title,
                description: announcement.description,
                tags: announcement.requiredSkills,
                telegramLink: announcement.telegramLink,
                isFavorite: announcement.id != null
                    ? authProvider.isFavorite(announcement.id!)
                    : false,
                onFavoriteToggle: announcement.id != null
                    ? () => authProvider.toggleFavorite(announcement.id!)
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}



                  // const PostCard(
                  //   name: 'Айгерім К.',
                  //   university: 'KBTU, 3 year',
                  //   title: 'Looking for Frontend (React) for a hackathon',
                  //   description:
                  //       'The "Digital Almaty" hackathon is in two weeks. We need someone to quickly build an MVP based on a pre-existing design.',
                  //   tags: ['ReactJS', 'TypeScript', 'Fast-paced'],
                  // ),
                  // const SizedBox(height: 16),
                  // const PostCard(
                  //   name: 'Нұрлан Б.',
                  //   university: 'L.N. Gumilyov ENU, 4th year student',
                  //   title: 'Looking for a UI/UX designer for a startup',
                  //   description:
                  //       "We're developing a mobile app for students. We need a creative designer to create the interface.",
                  //   tags: ['Figma', 'UI/UX', 'Startup'],
                  //   isAvatarText: true,
                  // ),
