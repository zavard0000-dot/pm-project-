import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:teamup/theme.dart';
import '../../feed_tab/widgets/post_card.dart';
import '../widgets/widgets.dart';

class FavoritesTabScreen extends StatefulWidget {
  const FavoritesTabScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesTabScreen> createState() => _FavoritesTabScreenState();
}

class _FavoritesTabScreenState extends State<FavoritesTabScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Красивый хеадер с градиентом
          const FavoritesHeader(),

          // Основной контент
          Expanded(
            child: Consumer<MyAuthProvider>(
              builder: (context, authProvider, _) {
                // Получаем ID текущего пользователя
                final currentUserId = authProvider.user?.uid;

                if (currentUserId == null) {
                  print('[FavoritesTabScreen] User not authenticated');
                  return Center(
                    child: Text(
                      'Вы не авторизованы',
                      style: isDarkMode
                          ? AppTextStyles.darkBodyLarge
                          : AppTextStyles.bodyLarge,
                    ),
                  );
                }

                // Получаем списки объявлений и избранных ID
                final allAnnouncements = authProvider.announcements;
                final favoriteIds = authProvider.favoriteAnnouncementIds;

                print(
                  '[FavoritesTabScreen] Building FavoritesTab: favorites=${favoriteIds.length}, total=${allAnnouncements.length}',
                );

                // Фильтруем объявления которые в избранном
                final favoriteAnnouncements = allAnnouncements
                    .where(
                      (announcement) =>
                          announcement.id != null &&
                          favoriteIds.contains(announcement.id),
                    )
                    .toList();

                // Пустое состояние
                if (favoriteAnnouncements.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_outline,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Нет избранных объявлений',
                          style: isDarkMode
                              ? AppTextStyles.darkHeadingSmall
                              : AppTextStyles.headingSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Добавьте объявления в избранное,\nчтобы они появились здесь',
                          textAlign: TextAlign.center,
                          style: isDarkMode
                              ? AppTextStyles.darkBodyMedium
                              : AppTextStyles.captionLarge,
                        ),
                      ],
                    ),
                  );
                }

                // Список избранных объявлений
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: favoriteAnnouncements.length,
                  itemBuilder: (context, index) {
                    final announcement = favoriteAnnouncements[index];

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Stack(
                        children: [
                          // PostCard
                          PostCard(
                            announcement: announcement,
                            isFavorite: true,
                            onFavoriteToggle: () async {
                              print(
                                '[FavoritesTabScreen] Attempting to remove favorite: ${announcement.id}',
                              );
                              _showRemoveFavoriteDialog(
                                context,
                                announcement,
                                authProvider,
                                isDarkMode,
                              );
                            },
                            isAvatarText:
                                announcement.userName != null &&
                                announcement.userName!.isNotEmpty,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Диалог для подтверждения удаления из избранного
  Future<void> _showRemoveFavoriteDialog(
    BuildContext context,
    dynamic announcement,
    MyAuthProvider authProvider,
    bool isDarkMode,
  ) async {
    print(
      '[FavoritesTabScreen] Showing remove favorite dialog for: ${announcement.id}',
    );

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? AppColors.darkSurface
              : AppColors.surface,
          title: Text(
            'Удалить из избранного?',
            style: isDarkMode
                ? AppTextStyles.darkHeadingSmall
                : AppTextStyles.headingSmall,
          ),
          content: Text(
            'Вы уверены, что хотите удалить это объявление из избранного?',
            style: isDarkMode
                ? AppTextStyles.darkBodyMedium
                : AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('[FavoritesTabScreen] Dialog dismissed');
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Отмена',
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                print(
                  '[FavoritesTabScreen] Confirmed removal of favorite: ${announcement.id}',
                );
                Navigator.of(dialogContext).pop();

                try {
                  await authProvider.toggleFavorite(announcement.id!);
                  print(
                    '[FavoritesTabScreen] Successfully removed from favorites: ${announcement.id}',
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Удалено из избранного',
                          style: isDarkMode
                              ? AppTextStyles.darkBodyMedium
                              : AppTextStyles.bodyMedium,
                        ),
                        backgroundColor: isDarkMode
                            ? AppColors.darkSurfaceVariant
                            : AppColors.background,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  print('[FavoritesTabScreen] Error removing favorite: $e');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Ошибка при удалении из избранного',
                          style: AppTextStyles.errorText,
                        ),
                        backgroundColor: AppColors.errorRed,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Удалить',
                style: TextStyle(color: AppColors.errorRed),
              ),
            ),
          ],
        );
      },
    );
  }
}
