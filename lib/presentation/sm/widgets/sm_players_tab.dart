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
          return Padding(
            padding: const EdgeInsets.all(24),
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
    final averageRating = totalPlayers > 0
        ? filteredPlayers
                .map((p) => p.averageRating)
                .reduce((a, b) => a + b) /
            totalPlayers
        : 0.0;

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
            ElevatedButton.icon(
                onPressed: () => _showAddPlayerDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Ajouter'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
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
              _buildStatCard(
                context,
                'Note moyenne',
                averageRating.toStringAsFixed(1),
                Icons.star,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
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
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Text('Trier par: '),
              const SizedBox(width: 8),
              ..._buildSortButtons(context, state),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSortButtons(BuildContext context, JoueursSmLoaded state) {
    final sortOptions = ['Nom', 'Note', 'Âge', 'Potentiel', 'Transfert', 'Salaire'];
    final sortFieldMap = {
      'Nom': SortField.name,
      'Note': SortField.rating,
      'Âge': SortField.age,
      'Potentiel': SortField.potential,
      'Transfert': SortField.transferValue,
      'Salaire': SortField.salary,
    };

    return sortOptions.map((option) {
      final isSelected = state.sortField != null && sortFieldMap[option] == state.sortField;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(option),
              if (isSelected)
                Icon(
                  state.sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                ),
            ],
          ),
          selected: isSelected,
          onSelected: (_) {
            context.read<JoueursSmBloc>().add(SortJoueursSmEvent(option));
          },
        ),
      );
    }).toList();
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