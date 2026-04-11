import 'package:flutter/material.dart';
import 'package:teamup/features/edit_profile/views/edit_profile_screen.dart';
import 'package:teamup/features/settings/settings.dart';
import 'package:teamup/models/models.dart';
import 'package:teamup/theme.dart';
import 'stat_card.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});
  final MyUser user;

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
          // Динамическая высота за счет padding
          padding: const EdgeInsets.only(
            top: 60, // Отступ для SafeArea (статус-бара)
            bottom:
                100, // ВАЖНО: Освобождаем место снизу для наезжающих карточек
            left: 24,
            right: 24,
          ),

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
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EditProfileScreen()),
                      );
                    },
                  ),
                  const Text('My Profile', style: AppTextStyles.appBarTitle),
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 42,
                  backgroundImage: NetworkImage(user.avatarLink),
                ),
              ),
              const SizedBox(height: 12),
              Text(user.fullName, style: AppTextStyles.whiteHeadingLarge),
              Text(user.username, style: AppTextStyles.whiteSubtle),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, color: Colors.white70, size: 16),
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
                      Icons.check_circle_outline,
                      color: Color(0xFF7C3AED),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Available for projects',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Карточки статистики, наезжающие на фон
        Positioned(
          bottom: -40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: user.stats
                .map(
                  (stat) => StatCard(
                    icon: stat.icon,
                    value: stat.value.toString(),
                    label: stat.title,
                    iconColor: stat.iconColor,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
