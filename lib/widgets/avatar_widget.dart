import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final String userName;
  final double radius;
  final bool showBorder;
  final VoidCallback? onTap;

  const AvatarWidget({
    Key? key,
    this.avatarUrl,
    required this.userName,
    this.radius = 24,
    this.showBorder = false,
    this.onTap,
  }) : super(key: key);

  String _getInitial(String name) {
    if (name.isEmpty) return 'A';
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final initial = _getInitial(userName);

    // Check if URL is valid (not empty, not just whitespace, and looks like a real URL)
    final isValidUrl =
        avatarUrl != null &&
        avatarUrl!.isNotEmpty &&
        (avatarUrl!.startsWith('http://') || avatarUrl!.startsWith('https://'));

    Widget avatar;

    if (isValidUrl) {
      // Avatar with image
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(avatarUrl!),
        onBackgroundImageError: (exception, stackTrace) {
          // Silently handle errors
        },
      );
    } else {
      // Avatar with initial letter (fallback)
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: isDarkMode
            ? AppColors.primaryPurple.withValues(alpha: 0.7)
            : AppColors.primaryBlue.withValues(alpha: 0.7),
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (showBorder) {
      avatar = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDarkMode
                ? AppColors.darkSurfaceVariant
                : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: avatar,
      );
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }

    return avatar;
  }
}
