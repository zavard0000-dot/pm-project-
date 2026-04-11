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
            label: email.isEmpty ? 'Not provided' : email,
            isPlaceholder: email.isEmpty,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 12),
          _ContactItem(
            icon: Icons.code,
            label: github.isEmpty ? 'Not provided' : github,
            isPlaceholder: github.isEmpty,
            color: isDarkMode ? AppColors.darkTextPrimary : Colors.black87,
          ),
          const SizedBox(height: 12),
          _ContactItem(
            icon: Icons.business,
            label: linkedin.isEmpty ? 'Not provided' : linkedin,
            isPlaceholder: linkedin.isEmpty,
            color: Color(0xFF0077B5),
          ),
          const SizedBox(height: 12),
          _ContactItem(
            icon: Icons.location_on_outlined,
            label: location.isEmpty ? 'Not provided' : location,
            isPlaceholder: location.isEmpty,
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
  final bool isPlaceholder;
  final Color color;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.isPlaceholder,
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
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
