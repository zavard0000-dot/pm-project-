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
  // @override
  // void initState() {
  //   super.initState();
  //   // Триггер #3: Инициализация страницы - загружаем объявления
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<MyAuthProvider>().loadAnnouncements();
  //   });
  // }

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
                announcement: announcement,
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
