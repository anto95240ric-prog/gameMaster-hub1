import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            const SizedBox(height: 48),
            _buildRecentActivity(context),
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
              stats: const {'Joueurs': '23', 'Note équipe': '87'},
              onTap: () => context.go('/sm'),
            ),
            GameCard(
              title: 'Football Manager',
              description: 'Gestion avancée et analyse détaillée',
              icon: Icons.stadium,
              priority: 2,
              stats: const {'Joueurs': '45', 'Note équipe': '92'},
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
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activité récente',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 24),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final activities = [
              {
                'icon': Icons.psychology,
                'title': 'Tactique optimisée',
                'description': 'Formation 4-3-3 recommandée pour Soccer Manager',
                'time': 'Il y a 2h',
              },
              {
                'icon': Icons.trending_up,
                'title': 'Progression joueur',
                'description': 'Anderson a gagné +3 points',
                'time': 'Il y a 5h',
              },
              {
                'icon': Icons.sync,
                'title': 'Synchronisation',
                'description': 'Données mises à jour avec succès',
                'time': 'Il y a 1j',
              },
            ];

            final activity = activities[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    activity['icon'] as IconData,
                    color: Colors.white,
                  ),
                ),
                title: Text(activity['title'] as String),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activity['description'] as String),
                    const SizedBox(height: 4),
                    Text(
                      activity['time'] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            );
          },
        ),
      ],
    );
  }
}