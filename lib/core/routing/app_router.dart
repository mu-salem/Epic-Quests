import 'package:epicquests/core/routing/route_constants.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/view/splash_screen.dart';
import '../../features/onboarding/view/avatar_selection_screen.dart';
import '../../features/tasks/view/tasks_home_screen.dart';


class AppRouter {
  static const String splash = '/';
  static const String onboardingAvatar = '/onboarding/avatar';
  static const String home = '/home';
  static const String addTask = '/task/add';
  static const String editTask = '/task/edit';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: splash,
        name: RouteConstants.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding: Avatar Selection
      GoRoute(
        path: onboardingAvatar,
        name: RouteConstants.onboardingAvatar,
        builder: (context, state) => const AvatarSelectionScreen(),
      ),

      // Home: Quest Log
      GoRoute(
        path: home,
        name: RouteConstants.home,
        builder: (context, state) {
          // Get hero name from query parameters
          final heroName = state.uri.queryParameters['hero'];
          return TasksHomeScreen(heroName: heroName);
        },
      ),
    ],
  );
}
