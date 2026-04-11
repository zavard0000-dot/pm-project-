import 'package:flutter/material.dart';
import 'package:teamup/widgets/widgets.dart';
import 'package:teamup/theme.dart';

class EventDetailsCard extends StatelessWidget {
  const EventDetailsCard();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title
          Row(
            children: [
              Text('⚡', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text(
                'Детали события',
                style: AppTextStyles.displayLarge.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.55,
            children: [
              _DetailTile(
                icon: Icons.calendar_today,
                iconColor: AppColors.primaryBlue,
                label: 'Дата',
                value: '5-7 апреля 2026',
                isDarkMode: isDarkMode,
              ),
              _DetailTile(
                icon: Icons.location_on_outlined,
                iconColor: Colors.red,
                label: 'Место',
                value: 'KBTU, Almaty',
                isDarkMode: isDarkMode,
              ),
              _DetailTile(
                icon: Icons.timelapse,
                iconColor: Colors.green,
                label: 'Формат',
                value: '2-3 дня',
                isDarkMode: isDarkMode,
              ),
              _DetailTile(
                icon: Icons.groups_2_outlined,
                iconColor: AppColors.primaryPurple,
                label: 'Команда',
                value: '3 человека',
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.isDarkMode,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkSurfaceVariant
            : const Color.fromARGB(255, 238, 238, 238),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.headingSmall.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
