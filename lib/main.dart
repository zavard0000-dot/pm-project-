import 'package:flutter/material.dart';
import 'package:teamup/features/auth/auth.dart';
import 'package:teamup/theme.dart';
//import 'package:teamup/widgets/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TeamUpApp());
}

class TeamUpApp extends StatelessWidget {
  const TeamUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) => MaterialApp(
        title: 'TeamUp Almaty',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: const LoginScreen(),
      ),
    );
  }
}
