import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class AuthorCard extends StatelessWidget {
  const AuthorCard();

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Image.network(
              'https://i.pravatar.cc/200?img=32',
              width: 58,
              height: 58,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Айгерім К.', style: AppTextStyles.headingLarge),
                SizedBox(height: 2),
                Text('КБТУ, 3 курс', style: AppTextStyles.bodyMedium),
                SizedBox(height: 2),
                Text(
                  'опубликовано 2 дня назад',
                  style: AppTextStyles.captionMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
