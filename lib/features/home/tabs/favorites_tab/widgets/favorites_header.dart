import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class FavoritesHeader extends StatelessWidget {
  const FavoritesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 32,
            left: 24,
            right: 24,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Иконка звезды с текстом
              Row(
                children: [
                  Icon(Icons.star, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text('Избранное', style: AppTextStyles.whiteHeadingLarge),
                ],
              ),
              const SizedBox(height: 12),
              // Подсказка
              Text(
                'Ваши сохраненные объявления',
                style: AppTextStyles.whiteCaption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
