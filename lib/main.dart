import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
// import 'data/core/database/hive_config.dart';
import 'presentation/core/blocs/auth/auth_bloc.dart';
// import 'presentation/core/blocs/theme/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  // await Hive.initFlutter();
  // await HiveConfig.init();
  
  // Initialize Supabase
  await dotenv.load(fileName: ".env");

  // Initialiser Supabase avec les valeurs du .env
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  
  runApp(
    MultiBlocProvider(
      providers: [
        // BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: const GameMasterHubApp(),
    ),
  );
}