import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class TelegramBtn extends StatelessWidget {
  const TelegramBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.telegram, color: Colors.white),
        label: const Text('Contact on Telegram'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode
              ? AppColors.primaryBlue.withOpacity(0.45)
              : AppColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isDarkMode ? 2 : 4,
        ),
      ),
    );
  }
}
