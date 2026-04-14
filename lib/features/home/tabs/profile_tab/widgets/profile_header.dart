import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teamup/models/models.dart';
import 'package:teamup/router.dart';
import 'package:teamup/theme.dart';
import 'stat_card.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    this.isCurrentUser = true,
    this.onAuthorTap,
  });

  final MyUser user;
  final bool isCurrentUser;
  final VoidCallback? onAuthorTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Gradient background
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 60,
            bottom: 100,
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
              // Top buttons row
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
                    const SizedBox(width: 48),
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Avatar
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
              if (user.location.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.white70, size: 16),
                    SizedBox(width: 4),
                    Text(user.location, style: AppTextStyles.whiteCaption),
                  ],
                ),
            ],
          ),
        ),
        // Stats cards
        Positioned(
          bottom: -40,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatCard(
                icon: Icons.folder_outlined,
                value: user.projectsCount.toString(),
                label: 'Projects',
                iconColor: AppColors.primaryBlue,
              ),
              StatCard(
                icon: Icons.people_outline,
                value: user.connectionsCount.toString(),
                label: 'Connections',
                iconColor: AppColors.primaryPurple,
              ),
              StatCard(
                icon: Icons.star_outline,
                value: user.achievementsCount.toString(),
                label: 'Achievements',
                iconColor: Colors.amber,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
