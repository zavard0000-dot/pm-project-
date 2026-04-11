import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class LocationCard extends StatelessWidget {
  final String location;

  const LocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final displayLocation = location.isEmpty ? 'Not provided' : location;
    final isPlaceholder = location.isEmpty;

    return BaseCard(
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: Colors.red, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📍 Location',
                  style: isDarkMode
                      ? AppTextStyles.darkHeadingSmall
                      : AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  displayLocation,
                  style:
                      (isDarkMode
                              ? AppTextStyles.darkBodyMedium
                              : AppTextStyles.bodyMedium)
                          .copyWith(
                            color: isPlaceholder
                                ? (isDarkMode
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary)
                                : null,
                            fontStyle: isPlaceholder
                                ? FontStyle.italic
                                : FontStyle.normal,
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
