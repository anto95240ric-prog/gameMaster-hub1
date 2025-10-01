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
      'name': 'Anderson',
      'position': 'ATT',
      'age': 24,
      'nationality': '🇧🇷 Brésil',
      'rating': 89,
      'value': '€12.5M',
      'progression': 3,
      'stats': {
        'Vitesse': 88,
        'Tir': 92,
        'Passes': 76,
        'Défense': 34,
        'Physique': 85,
        'Mental': 79,
      },
    },
    {
      'name': 'Rodriguez',
      'position': 'ATT',
      'age': 22,
      'nationality': '🇪🇸 Espagne',
      'rating': 86,
      'value': '€8.2M',
      'progression': 5,
      'stats': {
        'Vitesse': 91,
        'Tir': 87,
        'Passes': 82,
        'Défense': 28,
        'Physique': 78,
        'Mental': 74,
      },
    },
    {
      'name': 'Garcia',
      'position': 'MIL',
      'age': 26,
      'nationality': '🇫🇷 France',
      'rating': 82,
      'value': '€5.1M',
      'progression': 0,
      'stats': {
        'Vitesse': 75,
        'Tir': 68,
        'Passes': 89,
        'Défense': 76,
        'Physique': 82,
        'Mental': 85,
      },
    },
    {
      'name': 'Silva',
      'position': 'DEF',
      'age': 28,
      'nationality': '🇵🇹 Portugal',
      'rating': 84,
      'value': '€15M',
      'progression': 2,
      'stats': {
        'Vitesse': 72,
        'Tir': 45,
        'Passes': 84,
        'Défense': 92,
        'Physique': 88,
        'Mental': 90,
      },
    },
    {
      'name': 'Martinez',
      'position': 'DEF',
      'age': 25,
      'nationality': '🇦🇷 Argentine',
      'rating': 81,
      'value': '€12M',
      'progression': 4,
      'stats': {
        'Vitesse': 78,
        'Tir': 42,
        'Passes': 79,
        'Défense': 89,
        'Physique': 91,
        'Mental': 83,
      },
    },
    {
      'name': 'Wilson',
      'position': 'MIL',
      'age': 27,
      'nationality': '🏴󠁧󠁢󠁥󠁮󠁧󠁿 Angleterre',
      'rating': 83,
      'value': '€18M',
      'progression': 1,
      'stats': {
        'Vitesse': 81,
        'Tir': 74,
        'Passes': 87,
        'Défense': 69,
        'Physique': 84,
        'Mental': 88,
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
          player['position'].toString().contains(_getPositionFilter(selectedPosition));
      final matchesSearch = searchQuery.isEmpty ||
          player['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesPosition && matchesSearch;
    }).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300, // largeur max par carte
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: filteredPlayers.length,
      itemBuilder: (context, index) {
        final player = filteredPlayers[index];
        return _buildPlayerCard(context, player);
      },
    );
  }

  String _getPositionFilter(String position) {
    switch (position) {
      case 'Gardien':
        return 'GK';
      case 'Défenseur':
        return 'DEF';
      case 'Milieu':
        return 'MIL';
      case 'Attaquant':
        return 'ATT';
      default:
        return '';
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
                          '${player['position']} • ${player['age']} ans',
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
                ],
              ),
              const SizedBox(height: 12),
              Text(
                player['nationality'],
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    player['value'],
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getProgressionColor(player['progression']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      player['progression'] > 0 ? '+${player['progression']}' : '${player['progression']}',
                      style: TextStyle(
                        color: _getProgressionColor(player['progression']),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

  Color _getProgressionColor(int progression) {
    if (progression > 0) return Colors.green;
    if (progression < 0) return Colors.red;
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
                                  player['nationality'],
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getPositionColor(player['position']).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        player['position'],
                                        style: TextStyle(
                                          color: _getPositionColor(player['position']),
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
                      ...player['stats'].entries.map<Widget>((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(entry.key),
                                  Text(
                                    entry.value.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: entry.value / 100,
                                backgroundColor: Theme.of(context).dividerColor,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${player['name']} titularisé')),
                          );
                        },
                        icon: const Icon(Icons.star),
                        label: const Text('Titulariser'),
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
        return Colors.green;
      case 'DEF':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}