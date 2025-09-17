import 'package:flutter/material.dart';
import 'presentation/core/navigation/app_router.dart';
import 'presentation/core/themes/app_theme.dart';

class GameMasterHubApp extends StatelessWidget {
  const GameMasterHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'GameMaster Hub',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
