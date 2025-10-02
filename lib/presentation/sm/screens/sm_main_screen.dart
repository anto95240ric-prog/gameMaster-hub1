import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import '../widgets/sm_tactics_tab.dart';
import '../widgets/sm_players_tab.dart';
// import '../widgets/sm_matches_tab.dart';
// import '../widgets/sm_export_tab.dart';
import '../../core/blocs/auth/auth_bloc.dart';
import '../../core/blocs/theme/theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<SMPlayersTabState> smPlayersKey = GlobalKey<SMPlayersTabState>();

class SMMainScreen extends StatefulWidget {
  const SMMainScreen({super.key});

  @override
  State<SMMainScreen> createState() => _SMMainScreenState();
}

class _SMMainScreenState extends State<SMMainScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Row(
          children: [
            Icon(Icons.sports_soccer),
            SizedBox(width: 8),
            Text('Soccer Manager'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
            icon: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Icon(
                  state.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              smPlayersKey.currentState?.fetchPlayers();
            },
            icon: const Icon(Icons.sync),
          ),
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
              context.go('/auth');
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.group),
              text: 'Joueurs',
            ),
            // Tab(
            //   icon: Icon(Icons.psychology),
            //   text: 'Tactiques',
            // ),
            // Tab(
            //   icon: Icon(Icons.analytics),
            //   text: 'Matchs',
            // ),
            // Tab(
            //   icon: Icon(Icons.import_export),
            //   text: 'Export',
            // ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // SMTacticsTab(),
          SMPlayersTab(key: smPlayersKey),
          // SMMatchesTab(),
          // SMExportTab(),
        ],
      ),
    );
  }
}