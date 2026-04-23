import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class TelegramBtn extends StatelessWidget {
  final String? telegramLink;

  const TelegramBtn({super.key, this.telegramLink});

  Future<void> _launchTelegram(BuildContext context) async {
    print('[TelegramBtn] telegramLink: $telegramLink');

    if (telegramLink == null || telegramLink!.isEmpty) {
      print('[TelegramBtn] Telegram link is null or empty');
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Telegram link not available')),
        );
      }
      return;
    }

    try {
      String username = telegramLink!.replaceFirst('@', '');

      // Попытаемся открыть app-версию Telegram
      final Uri appUri = Uri.parse('tg://resolve?domain=$username');

      // Fallback на веб-версию
      final Uri webUri = Uri.parse('https://t.me/$username');

      print('[TelegramBtn] Trying app URI: $appUri');
      print('[TelegramBtn] Fallback web URI: $webUri');

      // Пытаемся открыть через app
      if (await canLaunchUrl(appUri)) {
        print('[TelegramBtn] Launching app URI');
        await launchUrl(appUri);
      } else if (await canLaunchUrl(webUri)) {
        print('[TelegramBtn] Launching web URI');
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        print('[TelegramBtn] Cannot launch any URI');
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open Telegram')),
          );
        }
      }
    } catch (e) {
      print('[TelegramBtn] Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _launchTelegram(context),
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
