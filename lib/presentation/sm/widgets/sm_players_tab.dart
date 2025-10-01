import 'package:flutter/material.dart';

class SMPlayersTab extends StatefulWidget {
  const SMPlayersTab({super.key});

  @override
  State<SMPlayersTab> createState() => _SMPlayersTabState();
}

class _SMPlayersTabState extends State<SMPlayersTab> {
  String selectedPosition = 'Tous les postes';
  String searchQuery = '';

  final List<Map<String, dynamic>> players = [
    {
      'name': 'Vitinha',
      'position': ['MDC', 'MC', 'MOC'],
      'age': 25,
      'rating': 91,
      'potentiel': 94,
      'value': '€70M',
      'status': 'Titulaire',
      'stats': {
          //Technique 
          'marquage': 70,
          'deplacement': 82,
          'frappes Lointaines': 82,
          'passesLongues': 85,
          'coupsFrancs': 70,
          'tacles': 70,
          'finition': 75,
          'centres': 75,
          'passes': 95,
          'corners': 75,
          'positionnement': 82,
          'dribble': 95,
          'controle': 88,
          'penalties': 65,
          'creativite': 81,
          // Physique
          'stabilite Aerienne': 64,
          'vitesse': 95,
          'endurance': 88,
          'force': 65,
          'distance Parcourue': 76,
          //Mental
          'agressivite': 65,
          'sangFroid': 95,
          'concentration': 82,
          'flair': 81,
          'leadership': 85,
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildFilters(context),
          const SizedBox(height: 24),
          Expanded(child: _buildPlayersGrid(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Définir la taille de la police en fonction de la largeur de l'écran
    final titleStyle = Theme.of(context).textTheme.displayMedium?.copyWith(
      fontSize: screenWidth < 600 ? 20 : 32, // mobile < 600 → 20, sinon 32
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Gestion des Joueurs',
          style: titleStyle,
        ),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Add player functionality
          },
          icon: const Icon(Icons.add),
          label: const Text('Ajouter'),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedPosition,
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
              setState(() {
                selectedPosition = value!;
              });
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
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersGrid(BuildContext context) {
    final filteredPlayers = players.where((player) {
      final matchesPosition = selectedPosition == 'Tous les postes' ||
          _getPositionFilter(selectedPosition)
              .any((pos) => (player['position'] as List<String>).contains(pos));
      final matchesSearch = searchQuery.isEmpty ||
          player['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesPosition && matchesSearch;
    }).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 315, // largeur max par carte
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: filteredPlayers.length,
      itemBuilder: (context, index) {
        final player = filteredPlayers[index];
        return _buildPlayerCard(context, player);
      },
    );
  }

  List<String> _getPositionFilter(String position) {
    switch (position) {
      case 'Gardien':
        return ['GK'];
      case 'Défenseur':
        return ['DC', 'DG', 'DD', 'DOG', 'DOD']; // tous les postes de défense
      case 'Milieu':
        return ['MC', 'MDC', 'MOC', 'MD', 'MG']; // tous les postes de milieu
      case 'Attaquant':
        return ['BU', 'MOD', 'MOG']; // tous les postes d'attaquant si besoin
      default:
        return [];
    }
  }

  Widget _buildPlayerCard(BuildContext context, Map<String, dynamic> player) {
    return Card(
      child: InkWell(
        onTap: () => _showPlayerDetails(context, player),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      player['name'][0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player['name'],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${(player['position'] as List).join("/")} • \n${player['age']} ans',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRatingColor(player['rating']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      player['rating'].toString(),
                      style: TextStyle(
                        color: _getRatingColor(player['rating']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRatingColor(player['potentiel']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      player['potentiel'].toString(),
                      style: TextStyle(
                        color: _getRatingColor(player['potentiel']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (player['status'] as String?) ?? 'Inconnu',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    player['value'],
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRatingColor(int rating) {
    if (rating >= 85) return Colors.green;
    if (rating >= 80) return Colors.blue;
    return Colors.orange;
  }

  Color _getProgressionColor(int potentiel) {
    if (potentiel > 0) return Colors.green;
    if (potentiel < 0) return Colors.red;
    return Colors.grey;
  }

  void _showPlayerDetails(BuildContext context, Map<String, dynamic> player) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Text(
                      player['name'],
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Player overview
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(
                              player['name'][0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player['status'],
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getPositionColor((player['position'] as List<String>).first).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        (player['position'] as List).join("/"),
                                        style: TextStyle(
                                          color: _getPositionColor((player['position'] as List).first), // prends la première pour la couleur
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text('${player['age']} ans'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getRatingColor(player['rating']).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        player['rating'].toString(),
                                        style: TextStyle(
                                          color: _getRatingColor(player['rating']),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getRatingColor(player['potentiel']).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        player['potentiel'].toString(),
                                        style: TextStyle(
                                          color: _getRatingColor(player['potentiel']),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(player['value']),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Statistics
                      Text(
                        'Statistiques détaillées',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      // Technique
                      _buildStatsCard(
                        context,
                        "Technique",
                        _filterStats(player['stats'], [
                          'marquage', 'deplacement', 'frappes Lointaines', 'passesLongues',
                          'coupsFrancs', 'tacles', 'finition', 'centres', 'passes', 'corners',
                          'positionnement', 'dribble', 'controle', 'penalties', 'creativite',
                        ]),
                      ),
                      const SizedBox(height: 16),
                      // Physique
                      _buildStatsCard(
                        context,
                        "Physique",
                        _filterStats(player['stats'], [
                          'stabilite Aerienne', 'vitesse', 'endurance', 'force', 'distance Parcourue',
                        ]),
                      ),
                      const SizedBox(height: 16),
                      // Mental
                      _buildStatsCard(
                        context,
                        "Mental",
                        _filterStats(player['stats'], [
                          'agressivite', 'sangFroid', 'concentration', 'flair', 'leadership',
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              // Actions
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Modification de ${player['name']}')),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Modifier'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPositionColor(String position) {
    switch (position) {
      case 'ATT':
        return Colors.red;
      case 'MIL':
      case 'MC':
      case 'MDC':
      case 'MOC':
        return Colors.green;
      case 'DEF':
      case 'DC':
      case 'DL':
      case 'DR':
        return Colors.blue;
      case 'GK':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Map<String, int> _filterStats(Map<String, int> stats, List<String> keys) {
    return Map.fromEntries(
      stats.entries.where((entry) => keys.contains(entry.key)),
    );
  }

Widget _buildStatsCard(BuildContext context, String title, Map<String, int> stats) {
  final entries = stats.entries.toList();
  
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          // Table pour 3 stats par ligne
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },
            children: List.generate(
              (entries.length / 3).ceil(),
              (rowIndex) {
                final start = rowIndex * 3;
                final end = (start + 3).clamp(0, entries.length);
                final rowEntries = entries.sublist(start, end);
                return TableRow(
                  children: List.generate(3, (colIndex) {
                    if (colIndex < rowEntries.length) {
                      final entry = rowEntries[colIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            Text(
                              entry.key,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.value.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Case vide pour compléter la ligne si moins de 3 stats
                      return const SizedBox();
                    }
                  }),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

}