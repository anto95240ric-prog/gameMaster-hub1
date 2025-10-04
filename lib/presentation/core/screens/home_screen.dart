import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_bloc.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_state.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/theme/theme_bloc.dart';
import '../widgets/game_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.sports_esports,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('GameMaster Hub'),
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
              context.read<AuthBloc>().add(AuthSignOutRequested());
              context.go('/auth');
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildWelcomeSection(context),
            const SizedBox(height: 48),
            _buildGamesGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      children: [
        Text(
          'Bienvenue dans GameMaster Hub',
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Choisissez votre jeu et optimisez vos performances',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

 Widget _buildGamesGrid(BuildContext context) {
  return BlocBuilder<JoueursSmBloc, JoueursSmState>(
    builder: (context, state) {
      int totalPlayersSM = 0;
      double averageRatingSM = 0;

      int totalPlayersFM = 0;
      double averageRatingFM = 0;

      // Si l'état est chargé, on calcule les stats dynamiquement
      if (state is JoueursSmLoaded) {
        final filteredPlayers = state.filteredJoueurs;
        totalPlayersSM = filteredPlayers.length;
        averageRatingSM = totalPlayersSM > 0
            ? filteredPlayers
                    .map((p) => p.joueur.niveauActuel)
                    .reduce((a, b) => a + b) /
                totalPlayersSM
            : 0;

        // Pour FM ou autres jeux, tu pourrais faire la même logique avec d'autres BLoC
        // Ici on met juste des valeurs fictives
        totalPlayersFM = 45;
        averageRatingFM = 92;
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.2,
            children: [
              GameCard(
                title: 'Soccer Manager',
                description: 'Optimiseur de tactique et suivi des joueurs',
                icon: Icons.sports_soccer,
                priority: 1,
                stats: {
                  'Joueurs': '$totalPlayersSM',
                  'Note équipe': averageRatingSM.toStringAsFixed(0),
                },
                onTap: () => context.go('/sm'),
              ),
              GameCard(
                title: 'Football Manager',
                description: 'Gestion avancée et analyse détaillée',
                icon: Icons.stadium,
                priority: 2,
                stats: {
                  'Joueurs': '$totalPlayersFM',
                  'Note équipe': averageRatingFM.toStringAsFixed(0),
                },
                onTap: () => context.go('/fm'),
              ),
              GameCard(
                title: 'Star Wars GoH',
                description: 'Optimiseur d\'équipe et simulateur',
                icon: Icons.rocket_launch,
                priority: 3,
                stats: const {'Personnages': '156', 'Puissance': '4.2M'},
                onTap: () => context.go('/swgoh'),
              ),
            ],
          );
        },
      );
    },
  );
}

}