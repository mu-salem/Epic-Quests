import 'package:epicquests/core/storage/preferences/local_storage_service.dart';
import 'package:epicquests/core/storage/hive/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_router.dart';
import 'core/network/api_client.dart';
import 'core/services/audio_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/sync_service.dart';
import 'core/theme/app_theme.dart';
import 'features/tasks/data/repositories/sync_hero_profile_repository.dart';
import 'features/tasks/viewmodel/tasks_viewmodel.dart';
import 'features/recurring/data/remote/api_recurring_quest_repository.dart';
import 'features/recurring/data/repository/sync_recurring_quest_repository.dart';
import 'features/recurring/viewmodel/recurring_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage services
  await LocalStorageService.init(); // SharedPreferences
  await HiveService.initHive(); // Hive
  await HiveService.openBoxes(); // Open all Hive boxes
  // Note: SecureStorageService needs no initialization

  // Initialize connectivity monitoring
  final connectivityService = ConnectivityService();
  await connectivityService.init();

  // Initialize sync service
  final syncService = SyncService();
  await syncService.init();

  // Initialize audio service
  await AudioService().init();

  // Initialize offline-first hero repository
  final heroRepository = SyncHeroProfileRepository();

  // Setup API client session expiration callback
  ApiClient.onSessionExpired = () {
    // Navigate to login screen when session expires
    AppRouter.router.go(AppRouter.login);
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: connectivityService),
        ChangeNotifierProvider.value(value: syncService),
        Provider.value(value: heroRepository),
        // TasksViewModel at root scope - survives navigation
        ChangeNotifierProvider(create: (_) => TasksViewModel()),
        // Recurring quests
        ChangeNotifierProvider(
          create: (_) => RecurringViewModel(
            repository: SyncRecurringQuestRepository(
              ApiRecurringQuestRepository(apiClient: ApiClient()),
            ),
          ),
        ),
      ],
      child: const EpicQuestsApp(),
    ),
  );
}

class EpicQuestsApp extends StatelessWidget {
  const EpicQuestsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Epic Quests',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
