import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_bloc.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_event.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_state.dart';
import 'package:gamemaster_hub/presentation/sm/widgets/add_player_dialog.dart';
import 'package:gamemaster_hub/presentation/sm/widgets/player_card_widget.dart';
import 'package:gamemaster_hub/presentation/sm/widgets/player_details_dialog.dart';

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

              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, state),
                        const SizedBox(height: 24),
                        _buildFilters(context, state),
                        const SizedBox(height: 24),
                        Expanded(child: _buildPlayersGrid(context, state)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: ElevatedButton.icon(
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

  Widget _buildHeader(BuildContext context, JoueursSmLoaded state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleStyle = Theme.of(context).textTheme.displayMedium?.copyWith(
          fontSize: screenWidth < 600 ? 20 : 32,
        );

    final filteredPlayers = state.filteredJoueurs;
    final totalPlayers = filteredPlayers.length;
    final averageNiveauActuel = totalPlayers > 0
        ? filteredPlayers
                .map((p) => p.joueur.niveauActuel)
                .reduce((a, b) => a + b) /
            totalPlayers
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Gestion des Joueurs',
                style: titleStyle,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  const SizedBox(width: 30),
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

  Widget _buildFilters(BuildContext context, JoueursSmLoaded state) {
   
    return Column(
      children: [
        Row(
          children: [
          // 🔹 Filtre position
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

            // 🔹 Filtre recherche
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
            const SizedBox(width: 16),

            // 🔹 Tri (dropdown au lieu de chips)
            Expanded(
              child: _buildSortControls(context, state),
            ),
          ],
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

  Widget _buildPlayersGrid(BuildContext context, JoueursSmLoaded state) {
    final filteredPlayers = state.filteredJoueurs;

    if (filteredPlayers.isEmpty) {
      return const Center(
        child: Text('Aucun joueur trouvé'),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 315,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
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