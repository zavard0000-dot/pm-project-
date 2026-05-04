import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teamup/models/models.dart';
import 'package:teamup/router.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';
import 'stat_card.dart';

class ProfileHeader extends StatelessWidget {
  final MyUser user;
  final bool isCurrentUser;

  const ProfileHeader({
    super.key,
    required this.user,
    this.isCurrentUser = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      //clipBehavior - обрезает элементы за границей
      clipBehavior: Clip.none,
      //базовое положение детей, кроме positioned
      alignment: Alignment.bottomCenter,
      children: [
        // Градиентный фон
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: (isDarkMode
                  ? [
                      Color.fromARGB(255, 23, 62, 148),
                      Color.fromARGB(255, 81, 37, 156),
                      Color.fromARGB(255, 113, 18, 61),
                    ]
                  : [Color(0xFF2563EB), Color(0xFF7C3AED), Color(0xFFDB2777)]),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              // Динамическая высота за счет padding
              padding: const EdgeInsets.only(
                top: 16,
                bottom:
                    30, // ВАЖНО: Освобождаем место снизу для наезжающих карточек
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isCurrentUser)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            context.go(AppRoutes.editProfile);
                          },
                        )
                      else
                        SizedBox(width: 48), // Placeholder for spacing
                      Text(
                        isCurrentUser ? 'My Profile' : 'Profile',
                        style: AppTextStyles.appBarTitle,
                      ),
                      if (isCurrentUser)
                        IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context.go(AppRoutes.settings);
                          },
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  UserAvatar(
                    username: user.fullName,
                    avatarLink: user.avatarLink,
                    radius: 45,
                    showBorder: true,
                  ),
                  const SizedBox(height: 12),
                  Text(user.fullName, style: AppTextStyles.whiteHeadingLarge),
                  Text(user.username, style: AppTextStyles.whiteSubtle),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school_outlined,
                        color: Colors.white70,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${user.universityName}, ${user.currentCourse} year • ${user.professionName}',
                        style: AppTextStyles.whiteCaption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getAvailabilityIcon(user.availability),
                          color: _getAvailabilityColor(user.availability),
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _getAvailabilityLabel(user.availability),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: _getAvailabilityColor(user.availability),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Карточки статистики, наезжающие на фон
            // Positioned(
            //   bottom: -40,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     spacing: 8,
            //     children: [
            //       StatCard(
            //         icon: Icons.track_changes,
            //         value: user.projectsCount.toString(),
            //         label: 'Projects',
            //         iconColor: Color(0xFF2563EB),
            //       ),
            //       StatCard(
            //         icon: Icons.people_outline,
            //         value: user.connectionsCount.toString(),
            //         label: 'Connections',
            //         iconColor: Color(0xFF7C3AED),
            //       ),
            //       StatCard(
            //         icon: Icons.emoji_events_outlined,
            //         value: user.achievementsCount.toString(),
            //         label: 'Achievements',
            //         iconColor: Color(0xFFDB2777),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ),
      ],
    );
  }

  String _getAvailabilityLabel(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Available for projects';
      case 'busy':
        return 'Busy at the moment';
      case 'unavailable':
        return 'Not available';
      default:
        return 'Available for projects';
    }
  }

  Color _getAvailabilityColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Color(0xFF7C3AED);
      case 'busy':
        return Colors.orange;
      case 'unavailable':
        return Colors.red;
      default:
        return Color(0xFF7C3AED);
    }
  }

  IconData _getAvailabilityIcon(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Icons.check_circle_outline;
      case 'busy':
        return Icons.schedule;
      case 'unavailable':
        return Icons.cancel;
      default:
        return Icons.check_circle_outline;
    }
  }
}
