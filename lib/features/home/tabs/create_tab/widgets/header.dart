import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 24,
            left: 16,
            right: 16,
          ),

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF7C3AED), Color(0xFFDB2777)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_outline_sharp, color: Colors.white),
              Text(
                " Create Announcement",
                style: AppTextStyles.whiteHeadingLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
