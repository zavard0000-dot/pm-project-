import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teamup/features/announcement_details/view/announcement_details_screen.dart';
import 'package:teamup/features/auth/view/login_screen.dart';
import 'package:teamup/features/auth/view/signup_screen.dart';
import 'package:teamup/features/edit_profile/views/edit_profile_screen.dart';
import 'package:teamup/features/home/view/home_screen.dart';
import 'package:teamup/features/onboarding/view/onboarding_screen.dart';
import 'package:teamup/features/settings/settings.dart';
import 'package:teamup/models/models.dart';
import 'package:teamup/providers/my_auth_provider.dart';

// ==================== ROUTE PATHS ====================
class AppRoutes {
  // Auth routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';

  // Home & nested routes
  static const String home = '/home';
  static const String profile = '/home/profile';
  static const String settings = '/home/settings';
  static const String editProfile = '/home/edit-profile';
  static const String announcementDetails = '/home/announcement/:id';
}

GoRouter createAppRouter(MyAuthProvider authProvider) {
  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    debugLogDiagnostics: true,

    // Слушает изменения в authProvider
    // реагирует только на notifyListeners()
    refreshListenable: authProvider,

    // вызывается при изменении refreshListenable
    redirect: (context, state) {
      print(
        '[Router.redirect] State: loading=${authProvider.isLoading}, authenticated=${authProvider.isAuthenticated}, path=${state.matchedLocation}',
      );

      // Пока инициализируется, остаёмся на splash
      // Это избегает видимых переходов между экранами
      if (authProvider.isLoading) {
        print('[Router.redirect] Loading, show splash');
        return AppRoutes.splash;
      }

      // После инициализации, если на splash - редиректим в зависимости от auth
      if (state.matchedLocation == AppRoutes.splash) {
        if (authProvider.isAuthenticated) {
          print('[Router.redirect] Authenticated, go to home');
          return AppRoutes.home;
        }
        // else {
        //   print('[Router.redirect] Not authenticated, go to onboarding');
        //   return AppRoutes.onboarding;
        // }
      }

      final isAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;

      // Если юзер авторизован и на auth странице - го на home
      if (authProvider.isAuthenticated && (isAuthRoute || isOnboarding)) {
        print('[Router.redirect] Authenticated on auth page, go to home');
        return AppRoutes.home;
      }

      // Если юзер не авторизован и на protected странице - го на onboarding
      if (!authProvider.isAuthenticated && !isAuthRoute && !isOnboarding) {
        print(
          '[Router.redirect] Not authenticated on protected page, go to onboarding',
        );
        return AppRoutes.login;
      }

      print('[Router.redirect] No redirect needed');
      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // Home с вложенными маршрутами
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const MainScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const MainScreen(initialTab: 4),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'edit-profile',
            name: 'editProfile',
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            path: 'announcement/:id',
            name: 'announcementDetails',
            builder: (context, state) {
              final announcementId = state.pathParameters['id'] ?? '';
              final announcement = state.extra as Announcement?;
              return AnnouncementDetailsScreen(
                announcementId: announcementId,
                announcement: announcement,
              );
            },
          ),
        ],
      ),
    ],
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text('TeamUp', style: Theme.of(context).textTheme.headlineLarge),
          ],
        ),
      ),
    );
  }
}
