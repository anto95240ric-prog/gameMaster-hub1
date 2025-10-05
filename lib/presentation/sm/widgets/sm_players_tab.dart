import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_bloc.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_event.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_state.dart';
import 'package:gamemaster_hub/presentation/sm/widgets/add_player_dialog.dart';
import 'package:gamemaster_hub/presentation/sm/widgets/player_card_widget.dart';
import 'package:gamemaster_hub/presentation/sm/widgets/player_details_dialog.dart';
import 'package:gamemaster_hub/presentation/core/utils/responsive_layout.dart';

class SMPlayersTab extends StatelessWidget {
  const SMPlayersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JoueursSmBloc, JoueursSmState>(
      builder: (context, state) {
        if (state is JoueursSmLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is JoueursSmError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Erreur: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<JoueursSmBloc>().add(LoadJoueursSmEvent()),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        } else if (state is JoueursSmLoaded) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final screenType = ResponsiveLayout.getScreenTypeFromWidth(constraints.maxWidth);
              final horizontalPadding = ResponsiveLayout.getHorizontalPadding(constraints.maxWidth);
              final verticalPadding = ResponsiveLayout.getVerticalPadding(constraints.maxWidth);

              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, state, constraints.maxWidth),
                        SizedBox(height: screenType == ScreenType.mobile ? 16 : 24),
                        _buildFilters(context, state, constraints.maxWidth),
                        SizedBox(height: screenType == ScreenType.mobile ? 16 : 24),
                        Expanded(child: _buildPlayersGrid(context, state, constraints.maxWidth)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: screenType == ScreenType.mobile
                        ? FloatingActionButton(
                            onPressed: () => _showAddPlayerDialog(context),
                            child: const Icon(Icons.add),
                          )
                        : ElevatedButton.icon(
                            onPressed: () => _showAddPlayerDialog(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Ajouter'),
                          ),
                  ),
                ],
              );
            },
          );
        }
        return const Center(child: Text('État inconnu'));
      },
    );
  }

  Widget _buildHeader(BuildContext context, JoueursSmLoaded state, double width) {
    final screenType = ResponsiveLayout.getScreenTypeFromWidth(width);
    final isMobile = screenType == ScreenType.mobile;

    final titleStyle = Theme.of(context).textTheme.displayMedium?.copyWith(
          fontSize: isMobile ? 20 : (screenType == ScreenType.tablet ? 26 : 32),
        );

    final filteredPlayers = state.filteredJoueurs;
    final totalPlayers = filteredPlayers.length;
    final averageNiveauActuel = totalPlayers > 0
        ? filteredPlayers
                .map((p) => p.joueur.niveauActuel)
                .reduce((a, b) => a + b) /
            totalPlayers
        : 0;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gestion des Joueurs',
            style: titleStyle,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Joueurs',
                  totalPlayers.toString(),
                  Icons.people,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Note',
                  averageNiveauActuel.toStringAsFixed(0),
                  Icons.star,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Gestion des Joueurs',
            style: titleStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenType == ScreenType.tablet ? 12 : 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                context,
                'Joueurs',
                totalPlayers.toString(),
                Icons.people,
              ),
              SizedBox(width: screenType == ScreenType.tablet ? 20 : 30),
              _buildStatCard(
                context,
                'Note',
                averageNiveauActuel.toStringAsFixed(0),
                Icons.star,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddPlayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddPlayerDialog(), // Bloc déjà accessible dans l'arbre
    );
  }

  Widget _buildFilters(BuildContext context, JoueursSmLoaded state, double width) {
    final screenType = ResponsiveLayout.getScreenTypeFromWidth(width);
    final isMobile = screenType == ScreenType.mobile;

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: state.selectedPosition,
                  decoration: const InputDecoration(
                    labelText: 'Position',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Tous les postes', 'Gardien', 'Défenseur', 'Milieu', 'Attaquant']
                      .map((position) => DropdownMenuItem(
                            value: position,
                            child: Text(position),
                          ))
                      .toList(),
                  onChanged: (value) {
                    context.read<JoueursSmBloc>().add(
                          FilterJoueursSmEvent(
                            position: value!,
                            searchQuery: state.searchQuery,
                          ),
                        );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Rechercher...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    context.read<JoueursSmBloc>().add(
                          FilterJoueursSmEvent(
                            position: state.selectedPosition,
                            searchQuery: value,
                          ),
                        );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSortControls(context, state),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: screenType == ScreenType.tablet ? 2 : 1,
          child: DropdownButtonFormField<String>(
            value: state.selectedPosition,
            decoration: const InputDecoration(
              labelText: 'Position',
              border: OutlineInputBorder(),
            ),
            items: ['Tous les postes', 'Gardien', 'Défenseur', 'Milieu', 'Attaquant']
                .map((position) => DropdownMenuItem(
                      value: position,
                      child: Text(position),
                    ))
                .toList(),
            onChanged: (value) {
              context.read<JoueursSmBloc>().add(
                    FilterJoueursSmEvent(
                      position: value!,
                      searchQuery: state.searchQuery,
                    ),
                  );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: screenType == ScreenType.tablet ? 3 : 2,
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Rechercher...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              context.read<JoueursSmBloc>().add(
                    FilterJoueursSmEvent(
                      position: state.selectedPosition,
                      searchQuery: value,
                    ),
                  );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: screenType == ScreenType.tablet ? 2 : 1,
          child: _buildSortControls(context, state),
        ),
      ],
    );
  }

  Widget _buildSortControls(BuildContext context, JoueursSmLoaded state) {
    final List<String> sortOptions = ['Nom', 'Note', 'Âge', 'Potentiel', 'Transfert', 'Salaire'];

    // Fonction pour convertir SortField -> String
    String sortFieldToString(SortField? field) {
      switch (field) {
        case SortField.name:
          return 'Nom';
        case SortField.rating:
          return 'Note';
        case SortField.age:
          return 'Âge';
        case SortField.potential:
          return 'Potentiel';
        case SortField.transferValue:
          return 'Transfert';
        case SortField.salary:
          return 'Salaire';
        default:
          return 'Nom';
      }
    }

    return Row(
      children: [
        // 🔹 Dropdown pour choisir le champ de tri
        Expanded(
          child: DropdownButtonFormField<String>(
            value: sortFieldToString(state.sortField),
            decoration: const InputDecoration(
              labelText: 'Trier par',
              border: OutlineInputBorder(),
            ),
            items: sortOptions
                .map<DropdownMenuItem<String>>(
                  (option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ),
                )
                .toList(),
            onChanged: (String? value) {
              if (value != null) {
                context.read<JoueursSmBloc>().add(
                      SortJoueursSmEvent(
                        sortField: value,
                        ascending: state.sortAscending,
                      ),
                    );
              }
            },
          ),
        ),
        const SizedBox(width: 12),

        // 🔹 Bouton pour basculer asc/desc
        IconButton(
          icon: Icon(
            state.sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
          ),
          onPressed: () {
            context.read<JoueursSmBloc>().add(
                  SortJoueursSmEvent(
                    sortField: sortFieldToString(state.sortField),
                    ascending: !state.sortAscending,
                  ),
                );
          },
        ),
      ],
    );
  }

  Widget _buildPlayersGrid(BuildContext context, JoueursSmLoaded state, double width) {
    final filteredPlayers = state.filteredJoueurs;
    final screenType = ResponsiveLayout.getScreenTypeFromWidth(width);

    if (filteredPlayers.isEmpty) {
      return const Center(
        child: Text('Aucun joueur trouvé'),
      );
    }

    int crossAxisCount;
    double childAspectRatio;
    double crossAxisSpacing;
    double mainAxisSpacing;

    switch (screenType) {
      case ScreenType.mobile:
        crossAxisCount = 1;
        childAspectRatio = 3.5;
        crossAxisSpacing = 12;
        mainAxisSpacing = 12;
        break;
      case ScreenType.tablet:
        crossAxisCount = 2;
        childAspectRatio = 3.0;
        crossAxisSpacing = 16;
        mainAxisSpacing = 16;
        break;
      case ScreenType.desktop:
        crossAxisCount = ResponsiveLayout.getCrossAxisCount(width);
        childAspectRatio = 2.5;
        crossAxisSpacing = 16;
        mainAxisSpacing = 16;
        break;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: filteredPlayers.length,
      itemBuilder: (context, index) {
        final item = filteredPlayers[index];
        return PlayerCardWidget(
          item: item,
          onTap: () => _showPlayerDetails(context, item),
        );
      },
    );
  }

  void _showPlayerDetails(BuildContext context, JoueurSmWithStats item) {
    showDialog(
      context: context,
      builder: (dialogContext) => PlayerDetailsDialog(item: item),
    );
  }
}