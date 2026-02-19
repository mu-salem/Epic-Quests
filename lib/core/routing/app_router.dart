import 'package:go_router/go_router.dart';

import '../../features/auth/view/screens/forgot_password_code_screen.dart';
import '../../features/auth/view/screens/forgot_password_email_screen.dart';
import '../../features/auth/view/screens/login_screen.dart';
import '../../features/auth/view/screens/register_screen.dart';
import '../../features/auth/view/screens/reset_password_screen.dart';
import '../../features/onboarding/view/screens/avatar_selection_screen.dart';
import '../../features/onboarding/view/screens/splash_screen.dart';
import '../../features/tasks/view/screens/tasks_home_screen.dart';


class AppRouter {
  static const String splash = '/';
  static const String onboardingAvatar = '/onboarding/avatar';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPasswordEmail = '/forgot-email';
  static const String forgotPasswordCode = '/forgot-code';
  static const String resetPassword = '/reset-password';
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
        name: splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth: Login
      GoRoute(
        path: login,
        name: login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Auth: Register
      GoRoute(
        path: register,
        name: register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // Auth: Forgot Password Email
      GoRoute(
        path: forgotPasswordEmail,
        name: forgotPasswordEmail,
        builder: (context, state) => const ForgotPasswordEmailScreen(),
      ),

      // Auth: Forgot Password Code
      GoRoute(
        path: forgotPasswordCode,
        name: forgotPasswordCode,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return ForgotPasswordCodeScreen(email: email);
        },
      ),

      // Auth: Reset Password
      GoRoute(
        path: resetPassword,
        name: resetPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final code = state.uri.queryParameters['code'] ?? '';
          return ResetPasswordScreen(email: email, code: code);
        },
      ),

      // Onboarding: Avatar Selection
      GoRoute(
        path: onboardingAvatar,
        name: onboardingAvatar,
        builder: (context, state) => const AvatarSelectionScreen(),
      ),

      // Home: Quest Log
      GoRoute(
        path: home,
        name: home,
        builder: (context, state) {
          // Get hero name from query parameters
          final heroName = state.uri.queryParameters['hero'];
          return TasksHomeScreen(heroName: heroName);
        },
      ),
    ],
  );
}
