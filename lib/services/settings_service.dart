import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyPush = 'push_notifications';
  static const String _keyEmail = 'email_notifications';
  static const String _keyMessages = 'messages_notifications';
  static const String _keyTheme = 'theme_mode';

  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  bool get pushNotifications => _prefs.getBool(_keyPush) ?? true;
  set pushNotifications(bool value) => _prefs.setBool(_keyPush, value);

  bool get emailNotifications => _prefs.getBool(_keyEmail) ?? true;
  set emailNotifications(bool value) => _prefs.setBool(_keyEmail, value);

  bool get messagesNotifications => _prefs.getBool(_keyMessages) ?? false;
  set messagesNotifications(bool value) => _prefs.setBool(_keyMessages, value);

  String get themeMode => _prefs.getString(_keyTheme) ?? 'system';
  set themeMode(String value) => _prefs.setString(_keyTheme, value);
}
