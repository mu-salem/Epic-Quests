import 'package:go_router/go_router.dart';
import '../../features/auth/view/screens/forgot_password_code_screen.dart';
import '../../features/auth/view/screens/forgot_password_email_screen.dart';
import '../../features/auth/view/screens/login_screen.dart';
import '../../features/auth/view/screens/register_screen.dart';
import '../../features/auth/view/screens/verify_email_screen.dart';
import '../../features/auth/view/screens/reset_password_screen.dart';
import '../../features/onboarding/view/screens/avatar_selection_screen.dart';
import '../../features/onboarding/view/screens/splash_screen.dart';
import '../../features/tasks/model/quest.dart';
import '../../features/tasks/view/screens/tasks_home_screen.dart';
import '../../features/tasks/view/screens/quest_details_screen.dart';
import '../../features/profile/view/screens/profile_screen.dart';
import '../../features/stats/view/screens/stats_screen.dart';
import '../../features/calendar/view/screens/calendar_screen.dart';
import '../../features/pomodoro/view/screens/pomodoro_screen.dart';
import '../../features/account/view/screens/account_settings_screen.dart';
import 'main_shell.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboardingAvatar = '/onboarding/avatar';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPasswordEmail = '/forgot-email';
  static const String forgotPasswordCode = '/forgot-code';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String stats = '/stats';
  static const String calendar = '/calendar';
  static const String questDetails = '/quest/:id';
  static const String pomodoro = '/pomodoro';
  static const String debug = '/debug';
  static const String account = '/account';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      // ─── Splash ────────────────────────────────
      GoRoute(
        path: splash,
        name: splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // ─── Auth ──────────────────────────────────
      GoRoute(
        path: login,
        name: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: verifyEmail,
        name: verifyEmail,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return VerifyEmailScreen(email: email);
        },
      ),
      GoRoute(
        path: forgotPasswordEmail,
        name: forgotPasswordEmail,
        builder: (context, state) => const ForgotPasswordEmailScreen(),
      ),
      GoRoute(
        path: forgotPasswordCode,
        name: forgotPasswordCode,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return ForgotPasswordCodeScreen(email: email);
        },
      ),
      GoRoute(
        path: resetPassword,
        name: resetPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final code = state.uri.queryParameters['code'] ?? '';
          return ResetPasswordScreen(email: email, code: code);
        },
      ),

      // ─── Onboarding ────────────────────────────
      GoRoute(
        path: onboardingAvatar,
        name: onboardingAvatar,
        builder: (context, state) => const AvatarSelectionScreen(),
      ),

      // ─── Main Shell (Bottom Nav) ────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          // Branch 0: Quests (Home)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                name: home,
                builder: (context, state) {
                  final heroName = state.uri.queryParameters['hero'];
                  return TasksHomeScreen(heroName: heroName);
                },
              ),
            ],
          ),
          // Branch 1: Hero Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profile,
                name: profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          // Branch 2: Stats
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: stats,
                name: stats,
                builder: (context, state) => const StatsScreen(),
              ),
            ],
          ),
          // Branch 3: Calendar
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: calendar,
                name: calendar,
                builder: (context, state) => const CalendarScreen(),
              ),
            ],
          ),
        ],
      ),

      // ─── Quest Details (outside shell) ─────────
      GoRoute(
        path: questDetails,
        name: questDetails,
        builder: (context, state) {
          final quest = state.extra as Quest;
          return QuestDetailsScreen(quest: quest);
        },
      ),

      // ─── Pomodoro Timer ──────────────────────────
      GoRoute(
        path: pomodoro,
        name: pomodoro,
        builder: (context, state) {
          final questId = state.uri.queryParameters['questId'];
          return PomodoroScreen(questId: questId);
        },
      ),

      // ─── Account Settings ────────────────────────
      GoRoute(
        path: account,
        name: account,
        builder: (context, state) => const AccountSettingsScreen(),
      ),
    ],
  );
}
