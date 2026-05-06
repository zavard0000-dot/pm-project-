import 'package:flutter/material.dart';
import 'package:teamup/main.dart';
import 'package:teamup/services/notification_history_service.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/base_card.dart';

class NotificationsTabScreen extends StatefulWidget {
  const NotificationsTabScreen({super.key});

  @override
  State<NotificationsTabScreen> createState() => _NotificationsTabScreenState();
}

class _NotificationsTabScreenState extends State<NotificationsTabScreen> {
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final data = await notificationHistoryService.getNotifications();
    setState(() {
      _notifications = data;
      _isLoading = false;
    });
  }

  Future<void> _clearAll() async {
    await notificationHistoryService.clearAll();
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              title: Text(
                'Notifications',
                style: AppTextStyles.appBarTitle.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              actions: [
                if (_notifications.isNotEmpty)
                  IconButton(
                    icon: Icon(
                      Icons.delete_sweep_outlined,
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear history?'),
                          content: const Text(
                            'This will delete all notification records.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _clearAll();
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Clear',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _notifications.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadNotifications,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final item = _notifications[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: BaseCard(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPurple.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.notifications_active_outlined,
                                      color: AppColors.primaryPurple,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.title,
                                                style:
                                                    (isDarkMode
                                                            ? AppTextStyles
                                                                  .darkBodyLarge
                                                            : AppTextStyles
                                                                  .bodyLarge)
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                            ),
                                            Text(
                                              _formatTime(item.timestamp),
                                              style:
                                                  (isDarkMode
                                                          ? AppTextStyles
                                                                .darkCaptionMedium
                                                          : AppTextStyles
                                                                .captionMedium)
                                                      .copyWith(
                                                        color: isDarkMode
                                                            ? AppColors
                                                                  .darkTextSecondary
                                                            : AppColors
                                                                  .textSecondary,
                                                      ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.body,
                                          style: isDarkMode
                                              ? AppTextStyles.darkBodyMedium
                                              : AppTextStyles.bodyMedium
                                                    .copyWith(
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 80,
            color: AppColors.primaryPurple.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style:
                (isDarkMode
                        ? AppTextStyles.darkHeadingSmall
                        : AppTextStyles.headingSmall)
                    .copyWith(
                      color: AppColors.primaryPurple.withValues(alpha: 0.7),
                    ),
          ),
          const SizedBox(height: 8),
          Text(
            'Recent updates and reminders\nwill appear here.',
            textAlign: TextAlign.center,
            style: isDarkMode
                ? AppTextStyles.darkCaptionMedium
                : AppTextStyles.captionMedium,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}.${dt.month}.${dt.year}';
  }
}
