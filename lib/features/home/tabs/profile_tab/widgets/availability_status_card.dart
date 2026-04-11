import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class AvailabilityStatusCard extends StatelessWidget {
  final String availability;

  const AvailabilityStatusCard({super.key, required this.availability});

  String _getAvailabilityLabel(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Available for opportunities';
      case 'busy':
        return 'Busy at the moment';
      case 'unavailable':
        return 'Not available';
      default:
        return 'Available for opportunities';
    }
  }

  Color _getAvailabilityColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'busy':
        return Colors.orange;
      case 'unavailable':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  IconData _getAvailabilityIcon(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Icons.check_circle;
      case 'busy':
        return Icons.schedule;
      case 'unavailable':
        return Icons.cancel;
      default:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getAvailabilityColor(availability);
    final statusLabel = _getAvailabilityLabel(availability);
    final statusIcon = _getAvailabilityIcon(availability);

    return BaseCard(
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🟢 Availability',
                  style: isDarkMode
                      ? AppTextStyles.darkHeadingSmall
                      : AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  statusLabel,
                  style:
                      (isDarkMode
                              ? AppTextStyles.darkBodyMedium
                              : AppTextStyles.bodyMedium)
                          .copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
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
