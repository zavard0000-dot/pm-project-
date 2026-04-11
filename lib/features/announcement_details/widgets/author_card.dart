import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class AuthorCard extends StatelessWidget {
  const AuthorCard();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BaseCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Image.network(
              'https://lh3.googleusercontent.com/vg_uEHrnRPq8H4MWqihO3W2xPPLZu6pbE9Vsq3rNAw_89N7gkaewBKYSmK1YbUM3mBz5bvSFP3dWAQZN=w544-h544-l90-rj',
              width: 58,
              height: 58,
              fit: BoxFit.cover,
              //placeholder
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 58,
                  height: 58,
                  color: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Айгерім К.',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'КБТУ, 3 курс',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'опубликовано 2 дня назад',
                  style: AppTextStyles.captionMedium.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
