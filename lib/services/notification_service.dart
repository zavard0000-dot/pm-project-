import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:teamup/main.dart';
import 'package:teamup/services/notification_history_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static final List<Map<String, String>> _messages = [
    {
      'title': 'Ready for a new team?',
      'body':
          'Check out fresh announcements and find your perfect partners today!',
    },
    {
      'title': 'Don\'t miss out!',
      'body':
          'Someone might be looking for a teammate like you. Open the app to see.',
    },
    {
      'title': 'New opportunities await!',
      'body':
          'The community is growing. See what projects are looking for contributors.',
    },
    {
      'title': 'Time to TeamUp!',
      'body':
          'A quick check might lead to your next big collaboration. Let\'s go!',
    },
    {
      'title': 'Any plans for today?',
      'body': 'Why not browse some team requests and share your expertise?',
    },
    {
      'title': 'Your team is waiting',
      'body':
          'New announcements have been posted. Find your spot in a new project.',
    },
    {
      'title': 'Skill swap time!',
      'body':
          'Find someone to learn from or help others with your unique skills.',
    },
  ];

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (details) async {
        // Handle notification tap
      },
    );

    // Request exact alarm permission for Android 13+
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      await androidPlugin.requestExactAlarmsPermission();
    }

    // Schedule and save to history if enabled
    if (settingsService.pushNotifications) {
      await scheduleDailyNotification();
    }
  }

  static Future<void> scheduleDailyNotification() async {
    // Cancel existing to avoid duplicates
    await _notifications.cancel(id: 100);

    final random = Random();
    final message = _messages[random.nextInt(_messages.length)];
    final String title = message['title']!;
    final String body = message['body']!;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription:
              'Daily reminder to check new team up opportunities',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.zonedSchedule(
      id: 100,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(10, 0), // Default to 10:00 AM
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // Save to history
    await notificationHistoryService.saveNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        timestamp: DateTime.now(),
      ),
    );
  }

  static Future<void> cancelDailyNotification() async {
    await _notifications.cancel(id: 100);
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}
