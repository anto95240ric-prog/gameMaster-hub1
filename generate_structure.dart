import 'dart:io';

void main() {
  final basePath = Directory.current.path + '/lib';

  final structure = {
    'data': {
      'sm': ['models', 'repositories', 'datasources'],
      'fm': ['models', 'repositories', 'datasources'],
      'swgoh': ['models', 'repositories', 'datasources'],
      'core': ['database', 'utils'],
    },
    'domain': {
      'sm': ['entities', 'usecases'],
      'fm': ['entities', 'usecases'],
      'swgoh': ['entities', 'usecases'],
      'core': ['repositories'],
    },
    'presentation': {
      'sm': ['screens', 'widgets', 'blocs'],
      'fm': ['screens', 'widgets', 'blocs'],
      'swgoh': ['screens', 'widgets', 'blocs'],
      'core': ['navigation', 'themes', 'widgets'],
    },
  };

  final codeSamples = {
    'models': '''
class Exemple {
  final String name;
  Exemple(this.name);
}
''',
    'entities': '''
class ExempleEntity {
  final String name;
  ExempleEntity(this.name);
}
''',
    'usecases': '''
class ExempleUsecase {
  void execute() => print('ExempleUsecase exécuté');
}
''',
    'repositories': '''
class ExempleRepository {
  void fetchData() => print('Données récupérées');
}
''',
    'datasources': '''
class ExempleDatasource {
  void getData() => print('Datasource exécutée');
}
''',
    'database': '''
class ExempleDatabase {
  void init() => print('Database initialisée');
}
''',
    'utils': '''
dynamic exempleUtil(dynamic input) {
  return input;
}
''',
    'screens': '''
import 'package:flutter/material.dart';

class ExempleScreen extends StatelessWidget {
  const ExempleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Exemple Screen')));
  }
}
''',
    'widgets': '''
import 'package:flutter/material.dart';

class ExempleWidget extends StatelessWidget {
  const ExempleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Exemple Widget'));
  }
}
''',
    'blocs': '''
import 'package:flutter_bloc/flutter_bloc.dart';

class ExempleCubit extends Cubit<int> {
  ExempleCubit() : super(0);
  void increment() => emit(state + 1);
}
''',
    'navigation': '''
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Placeholder()),
  ],
);
''',
    'themes': '''
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData.light();
  static final darkTheme = ThemeData.dark();
}
''',
  };

  structure.forEach((level, modules) {
    modules.forEach((module, subfolders) {
      subfolders.forEach((sub) {
        final dir = Directory('$basePath/$level/$module/$sub');
        dir.createSync(recursive: true);
        final file = File('${dir.path}/exemple.dart');
        file.writeAsStringSync(codeSamples[sub] ?? "void exemple(){}");
        print('Créé: ${file.path}');
      });
    });
  });

  // Créer main.dart et app.dart
  final mainFile = File('$basePath/main.dart');
  mainFile.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const GameMasterHubApp());
}
''');

  final appFile = File('$basePath/app.dart');
  appFile.writeAsStringSync('''
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
''');

  print('Structure de lib/ créée avec tous les fichiers exemple.');
}
