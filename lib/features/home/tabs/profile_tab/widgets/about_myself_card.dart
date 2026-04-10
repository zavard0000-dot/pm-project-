import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class AboutMyselfCard extends StatelessWidget {
  final String content;

  const AboutMyselfCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📝 About myself', style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          Text(content, style: AppTextStyles.captionLarge),
        ],
      ),
    );
  }
}
