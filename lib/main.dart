import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teamup/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/services/auth_service.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:teamup/router.dart';
import 'firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamup/services/settings_service.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
late final SettingsService settingsService;

final authService = AuthService(
  firebaseAuth: FirebaseAuth.instance,
  firestore: FirebaseFirestore.instance,
);

// Router создаётся один раз при запуске приложения
late final MyAuthProvider _authProvider;
late final GoRouter _appRouter;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем SharedPreferences и SettingsService
  final prefs = await SharedPreferences.getInstance();
  settingsService = SettingsService(prefs);

  // Устанавливаем сохраненную тему
  final savedTheme = settingsService.themeMode;
  themeNotifier.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase init error: $e');
  }

  // Web URL strategy (убираем # из url)
  setPathUrlStrategy();

  // Инициализируем провайдер и router ДО запуска приложения
  _authProvider = MyAuthProvider(authService: authService);
  _appRouter = createAppRouter(_authProvider);

  runApp(const TeamUpApp());
}

class TeamUpApp extends StatelessWidget {
  const TeamUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: _authProvider)],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, themeMode, child) {
          return MaterialApp.router(
            title: 'TeamUp Almaty',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: _appRouter,
          );
        },
      ),
    );
  }
}
