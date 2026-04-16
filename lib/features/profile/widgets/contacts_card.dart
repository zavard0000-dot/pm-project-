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
            '📇 Контакты',
            style: isDarkMode
                ? AppTextStyles.darkHeadingSmall
                : AppTextStyles.headingSmall,
          ),
          const SizedBox(height: 16),
          if (email.isNotEmpty)
            _ContactItem(
              icon: Icons.email_outlined,
              label: email,
              color: AppColors.primaryBlue,
            ),
          if (email.isNotEmpty) const SizedBox(height: 12),
          if (github.isNotEmpty)
            _ContactItem(
              icon: Icons.code,
              label: github,
              color: isDarkMode ? AppColors.darkTextPrimary : Colors.black87,
            ),
          if (github.isNotEmpty) const SizedBox(height: 12),
          if (linkedin.isNotEmpty)
            _ContactItem(
              icon: Icons.business,
              label: linkedin,
              color: Color(0xFF0077B5),
            ),
          if (linkedin.isNotEmpty) const SizedBox(height: 12),
          if (location.isNotEmpty)
            _ContactItem(
              icon: Icons.location_on_outlined,
              label: location,
              color: Colors.green,
            ),
          if (email.isEmpty &&
              github.isEmpty &&
              linkedin.isEmpty &&
              location.isEmpty)
            Text(
              'Контакты не указаны',
              style: isDarkMode
                  ? AppTextStyles.darkCaptionMedium
                  : AppTextStyles.captionMedium,
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
            style:
                (isDarkMode
                        ? AppTextStyles.darkBodyMedium
                        : AppTextStyles.bodyMedium)
                    .copyWith(overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}
