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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Telegram link not available')),
        );
      }
      return;
    }

    try {
      // Обработка разных форматов ссылок
      String urlToLaunch = telegramLink!;

      // Если это просто юзернейм (например @username), преобразовать в полную ссылку
      if (telegramLink!.startsWith('@')) {
        urlToLaunch = 'https://t.me/${telegramLink!.replaceFirst('@', '')}';
      }
      // Если это уже полная ссылка
      else if (!telegramLink!.startsWith('http') &&
          !telegramLink!.startsWith('tg://')) {
        urlToLaunch = 'https://t.me/$telegramLink';
      }

      print('[TelegramBtn] Final URL to launch: $urlToLaunch');

      final Uri telegramUri = Uri.parse(urlToLaunch);
      if (await canLaunchUrl(telegramUri)) {
        await launchUrl(telegramUri);
        print('[TelegramBtn] Successfully launched Telegram link');
      } else {
        print('[TelegramBtn] Cannot launch URL: $urlToLaunch');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open Telegram')),
          );
        }
      }
    } catch (e) {
      print('[TelegramBtn] Error: $e');
      if (context.mounted) {
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
