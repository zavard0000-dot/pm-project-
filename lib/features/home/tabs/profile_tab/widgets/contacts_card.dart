import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class ContactsCard extends StatelessWidget {
  final String email;
  final String github;
  final String linkedin;
  final String location;

  const ContactsCard({
    super.key,
    required this.email,
    required this.github,
    required this.linkedin,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📇 Contacts',
            style: isDarkMode
                ? AppTextStyles.darkHeadingSmall
                : AppTextStyles.headingSmall,
          ),
          const SizedBox(height: 16),
          _ContactItem(
            icon: Icons.email_outlined,
            label: email,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 12),
          _ContactItem(
            icon: Icons.code,
            label: github,
            color: isDarkMode ? AppColors.darkTextPrimary : Colors.black87,
          ),
          const SizedBox(height: 12),
          _ContactItem(
            icon: Icons.business,
            label: linkedin,
            color: Color(0xFF0077B5),
          ),
          const SizedBox(height: 12),
          _ContactItem(
            icon: Icons.location_on_outlined,
            label: location,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: isDarkMode
                ? AppTextStyles.darkBodyMedium
                : AppTextStyles.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
