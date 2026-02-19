import 'package:epicquests/core/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/tasks/viewmodel/tasks_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorageService.init();

  runApp(const EpicQuestsApp());
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
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TasksViewModel()),
          ],
          child: MaterialApp.router(
            title: 'Epic Quests',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
