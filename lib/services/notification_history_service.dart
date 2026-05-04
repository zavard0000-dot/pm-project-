import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        timestamp: DateTime.parse(json['timestamp']),
        isRead: json['isRead'] ?? false,
      );
}

class NotificationHistoryService {
  static const String _key = 'notifications_history';
  final SharedPreferences _prefs;

  NotificationHistoryService(this._prefs);

  Future<void> saveNotification(AppNotification notification) async {
    final List<AppNotification> current = await getNotifications();
    current.insert(0, notification);
    // Keep only last 50 notifications
    if (current.length > 50) current.removeLast();

    final List<String> encoded = current
        .map((n) => jsonEncode(n.toJson()))
        .toList();
    await _prefs.setStringList(_key, encoded);
  }

  Future<List<AppNotification>> getNotifications() async {
    final List<String>? encoded = _prefs.getStringList(_key);
    if (encoded == null) return [];
    return encoded.map((s) => AppNotification.fromJson(jsonDecode(s))).toList();
  }

  Future<void> clearAll() async {
    await _prefs.remove(_key);
  }

  Future<void> markAsRead(String id) async {
    final List<AppNotification> current = await getNotifications();
    final index = current.indexWhere((n) => n.id == id);
    if (index != -1) {
      final old = current[index];
      current[index] = AppNotification(
        id: old.id,
        title: old.title,
        body: old.body,
        timestamp: old.timestamp,
        isRead: true,
      );
      final List<String> encoded = current
          .map((n) => jsonEncode(n.toJson()))
          .toList();
      await _prefs.setStringList(_key, encoded);
    }
  }
}
