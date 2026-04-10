import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/bases/base_card.dart';

class SettingSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: isDarkMode
              ? AppTextStyles.darkHeadingSmall
              : AppTextStyles.headingSmall,
        ),
        const SizedBox(height: 12),
        BaseCard(
          child: Column(
            children: children.asMap().entries.map((entry) {
              final isLast = entry.key == children.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast)
                    Divider(
                      color: isDarkMode
                          ? AppColors.darkInputBorder
                          : Color(0xFFE5E7EB),
                      height: 1,
                      thickness: 1,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
