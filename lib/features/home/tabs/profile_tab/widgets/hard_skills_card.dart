import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';
import 'skill_chip.dart';

class HardSkillsCard extends StatelessWidget {
  final List<String> skills;

  const HardSkillsCard({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚡ Skills',
            style: isDarkMode
                ? AppTextStyles.darkHeadingSmall
                : AppTextStyles.headingSmall,
          ),
          const SizedBox(height: 12),
          if (skills.isEmpty)
            Text(
              'No skills added yet',
              style: isDarkMode
                  ? AppTextStyles.darkCaptionMedium
                  : AppTextStyles.captionMedium,
            ),
          if (skills.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) => SkillChip(label: skill)).toList(),
            ),
        ],
      ),
    );
  }
}
