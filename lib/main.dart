import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:gamemaster_hub/presentation/core/blocs/auth/auth_bloc.dart';
import 'package:gamemaster_hub/presentation/core/blocs/theme/theme_bloc.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_bloc.dart';
import 'package:gamemaster_hub/data/sm/repositories/joueur_sm_repository_impl.dart';
import 'package:gamemaster_hub/data/sm/repositories/stats_joueur_sm_repository_impl.dart';
import 'package:gamemaster_hub/data/sm/datasources/joueur_sm_remote_data_source.dart';
import 'package:gamemaster_hub/data/sm/datasources/stats_joueur_sm_remote_data_source.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger le .env
  await dotenv.load(fileName: "assets/.env");

  // Initialiser Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // Initialiser Hive pour le theme
  await Hive.initFlutter();
  await Hive.openBox('theme_box');

  final supabaseClient = Supabase.instance.client;

  final joueurRepository = JoueurSmRepositoryImpl(
    JoueurSmRemoteDataSourceImpl(supabaseClient), // <-- passer le client ici
  );

  final statsRepository = StatsJoueurSmRepositoryImpl(
    StatsJoueurSmRemoteDataSource(supabaseClient),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: const GameMasterHubApp(),
    ),
  );
}
