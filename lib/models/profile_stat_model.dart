// StatCard(
//                 icon: Icons.emoji_events_outlined,
//                 value: user.stats["achievements"].toString(),
//                 label: 'Achievements',
//                 iconColor: const Color(0xFFDB2777),
//               ),

import 'package:flutter/material.dart';

class ProfileStatModel {
  const ProfileStatModel({
    required this.icon,
    required this.value,
    required this.title,
    required this.iconColor,
  });

  final IconData icon;
  final int value;
  final String title;
  final Color iconColor;
}
