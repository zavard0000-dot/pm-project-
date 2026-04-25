import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class EditProfileHeader extends StatelessWidget {
  const EditProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          // Динамическая высота за счет padding
          padding: const EdgeInsets.only(
            top: 40, // Отступ для SafeArea (статус-бара)
            bottom:
                24, // ВАЖНО: Освобождаем место снизу для наезжающих карточек
            left: 16,
            right: 16,
          ),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      const Color(0xFF1E3A8A),
                      const Color(0xFF581C87),
                      const Color(0xFF7F1D1D),
                    ]
                  : [
                      AppColors.primaryBlue,
                      AppColors.primaryPurple,
                      AppColors.accentPink,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                  SizedBox(width: 48),
                  Icon(Icons.star_outline_sharp, color: Colors.white),
                  Text(" Edit Profile", style: AppTextStyles.whiteHeadingLarge),
                ],
              ),

              SizedBox(height: 24),

              UserAvatar(username: 'User', avatarLink: null, radius: 60),
              SizedBox(height: 8),
              Text(
                "нажми для редактирование профеля",
                style: AppTextStyles.whiteCaption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
