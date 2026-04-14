import 'package:flutter/material.dart';
import 'package:teamup/models/announcement.dart';
import 'package:teamup/widgets/widgets.dart';
import 'package:teamup/theme.dart';

class EventDetailsCard extends StatelessWidget {
  final Announcement announcement;

  const EventDetailsCard({required this.announcement});

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatDateRange() {
    if (announcement.eventDateStart == null &&
        announcement.eventDateEnd == null) {
      return '-';
    }
    final startDate = announcement.eventDateStart != null
        ? _formatDate(announcement.eventDateStart)
        : '?';
    final endDate = announcement.eventDateEnd != null
        ? _formatDate(announcement.eventDateEnd)
        : '?';
    if (startDate == endDate) {
      return startDate;
    }
    return '$startDate - $endDate';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Check if there's any event details to show
    final hasEventDetails =
        announcement.eventDateStart != null ||
        announcement.eventDateEnd != null ||
        announcement.eventLocation != null ||
        announcement.requiredTeamSize != null;

    if (!hasEventDetails) {
      return SizedBox.shrink();
    }

    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('⚡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Детали события',
                style: AppTextStyles.headingMedium.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.55,
            children: [
              if (announcement.eventDateStart != null ||
                  announcement.eventDateEnd != null)
                _DetailTile(
                  icon: Icons.calendar_today,
                  iconColor: AppColors.primaryBlue,
                  label: 'Дата',
                  value: _formatDateRange(),
                  isDarkMode: isDarkMode,
                ),
              if (announcement.eventLocation != null &&
                  announcement.eventLocation!.isNotEmpty)
                _DetailTile(
                  icon: Icons.location_on_outlined,
                  iconColor: Colors.red,
                  label: 'Место',
                  value: announcement.eventLocation!,
                  isDarkMode: isDarkMode,
                ),
              if (announcement.eventType.isNotEmpty)
                _DetailTile(
                  icon: Icons.bookmark_outline,
                  iconColor: Colors.orange,
                  label: 'Формат',
                  value: announcement.eventType,
                  isDarkMode: isDarkMode,
                ),
              if (announcement.requiredTeamSize != null)
                _DetailTile(
                  icon: Icons.groups_2_outlined,
                  iconColor: AppColors.primaryPurple,
                  label: 'Команда',
                  value: '${announcement.requiredTeamSize} человек',
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
