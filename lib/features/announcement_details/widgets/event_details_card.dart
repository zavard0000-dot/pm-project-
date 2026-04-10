import 'package:flutter/material.dart';
import 'package:teamup/widgets/widgets.dart';
import 'package:teamup/theme.dart';

class EventDetailsCard extends StatelessWidget {
  const EventDetailsCard();

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title
          const Row(
            children: [
              Text('⚡', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text('Детали события', style: AppTextStyles.displayLarge),
            ],
          ),
          // const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.55,
            children: const [
              _DetailTile(
                icon: Icons.calendar_today,
                iconColor: AppColors.primaryBlue,
                label: 'Дата',
                value: '5-7 апреля 2026',
              ),
              _DetailTile(
                icon: Icons.location_on_outlined,
                iconColor: Colors.red,
                label: 'Место',
                value: 'KBTU, Almaty',
              ),
              _DetailTile(
                icon: Icons.timelapse,
                iconColor: Colors.green,
                label: 'Формат',
                value: '2-3 дня',
              ),
              _DetailTile(
                icon: Icons.groups_2_outlined,
                iconColor: AppColors.primaryPurple,
                label: 'Команда',
                value: '3 человека',
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
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 238, 238),
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
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.headingSmall),
        ],
      ),
    );
  }
}
