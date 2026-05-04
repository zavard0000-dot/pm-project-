import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class Header extends StatelessWidget {
  final String? title;
  final bool showBackButton;

  const Header({super.key, this.title, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: (isDarkMode
              ? [
                  const Color.fromARGB(255, 23, 62, 148),
                  const Color.fromARGB(255, 81, 37, 156),
                  const Color.fromARGB(255, 113, 18, 61),
                ]
              : [
                  const Color(0xFF2563EB),
                  const Color(0xFF7C3AED),
                  const Color(0xFFDB2777),
                ]),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Row(
            mainAxisAlignment: showBackButton
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              if (showBackButton) ...[
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
              ],
              const Icon(Icons.star_outline_sharp, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                title ?? "Create Announcement",
                style: AppTextStyles.whiteHeadingLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
