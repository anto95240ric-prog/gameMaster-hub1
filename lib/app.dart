import 'package:flutter/material.dart';
import 'presentation/core/navigation/exemple.dart';
import 'presentation/core/themes/exemple.dart';

class GameMasterHubApp extends StatelessWidget {
  const GameMasterHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GameMaster Hub',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
