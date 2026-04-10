import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class CurrentProjectCard extends StatelessWidget {
  const CurrentProjectCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder_outlined, color: Color(0xFF7C3AED)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.captionMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
