import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class StatCard extends StatelessWidget {
  final int number;
  final String label;

  const StatCard({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number.toString(),
            style:
                (isDarkMode
                        ? AppTextStyles.darkBodyLarge
                        : AppTextStyles.statNumber)
                    .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: isDarkMode
                ? AppTextStyles.darkCaptionMedium
                : AppTextStyles.statLabel,
          ),
        ],
      ),
    );
  }
}
