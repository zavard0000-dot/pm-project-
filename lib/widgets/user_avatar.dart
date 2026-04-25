import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class UserAvatar extends StatelessWidget {
  final String? username;
  final String? avatarLink;
  final double radius;
  final TextStyle? textStyle;
  final bool showBorder;
  final double borderWidth;

  const UserAvatar({
    Key? key,
    this.username,
    this.avatarLink,
    this.radius = 20,
    this.textStyle,
    this.showBorder = false,
    this.borderWidth = 2,
  }) : super(key: key);

  String _getInitial() {
    if (username == null || username!.isEmpty) {
      return '?';
    }
    // Убираем @ если есть в начале
    final cleanUsername = username!.startsWith('@')
        ? username!.substring(1)
        : username!;
    return cleanUsername.isNotEmpty ? cleanUsername[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    // Если есть ссылка на аватарку, показываем изображение
    Widget avatar;

    if (avatarLink != null && avatarLink!.isNotEmpty) {
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[300],
        backgroundImage: NetworkImage(avatarLink!),
        onBackgroundImageError: (exception, stackTrace) {
          // Если ошибка загрузки, покажет дефолтное изображение
        },
      );
    } else {
      // Если нет ссылки, показываем первую букву
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.7),
        child: Text(
          _getInitial(),
          style:
              textStyle ??
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.8,
              ),
        ),
      );
    }

    // Добавляем белую обводку если нужно
    if (showBorder) {
      avatar = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.6),
            width: borderWidth,
          ),
        ),
        child: avatar,
      );
    }

    return avatar;
  }
}
