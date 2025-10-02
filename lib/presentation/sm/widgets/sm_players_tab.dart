import 'package:flutter/material.dart';
import 'package:gamemaster_hub/domain/sm/entities/joueur_sm.dart';
import 'package:gamemaster_hub/domain/sm/entities/stats_joueur_sm.dart';
import 'package:gamemaster_hub/domain/common/enums.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SMPlayersTab extends StatefulWidget {
  const SMPlayersTab({super.key});

  @override
  State<SMPlayersTab> createState() => SMPlayersTabState();
}

class SMPlayersTabState extends State<SMPlayersTab> {
  String selectedPosition = 'Tous les postes';
  String searchQuery = '';

  List<Map<String, dynamic>> players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    final response = await Supabase.instance.client
        .from('joueur_sm')
        .select('*, stats_joueur_sm(*)')
        .eq('user_id', Supabase.instance.client.auth.currentUser!.id);

    print(response);
    final data = response as List<dynamic>;

    setState(() {
      players = data.map((row) {
        final joueur = JoueurSm(
          id: row['id'],
          nom: row['nom'],
          age: row['age'],
          postes: (row['postes'] as List<dynamic>)
              .map((p) => PosteEnum.values.firstWhere((e) => e.name == p))
              .toList(), // ✅ conversion tableau texte → liste PosteEnum
          niveauActuel: row['niveau_actuel'],
          potentiel: row['potentiel'],
          montantTransfert: row['montant_transfert'],
          status: StatusEnum.values.firstWhere((e) => e.name == row['status']),
          dureeContrat: row['duree_contrat'],
          salaire: row['salaire'],
          userId: row['user_id'],
        );

        final statsRow = (row['stats_joueur_sm'] as List).isNotEmpty
            ? row['stats_joueur_sm'][0]
            : null;

        final stats = statsRow != null
            ? StatsJoueurSm(
                id: statsRow['id'],
                joueurId: statsRow['joueur_id'],
                marquage: statsRow['marquage'],
                deplacement: statsRow['deplacement'],
                frappesLointaines: statsRow['frappes_lointaines'],
                passesLongues: statsRow['passes_longues'],
                coupsFrancs: statsRow['coups_francs'],
                tacles: statsRow['tacles'],
                finition: statsRow['finition'],
                centres: statsRow['centres'],
                passes: statsRow['passes'],
                corners: statsRow['corners'],
                positionnement: statsRow['positionnement'],
                dribble: statsRow['dribble'],
                controle: statsRow['controle'],
                penalties: statsRow['penalties'],
                creativite: statsRow['creativite'],
                stabiliteAerienne: statsRow['stabilite_aerienne'],
                vitesse: statsRow['vitesse'],
                endurance: statsRow['endurance'],
                force: statsRow['force'],
                distanceParcourue: statsRow['distance_parcourue'],
                agressivite: statsRow['agressivite'],
                sangFroid: statsRow['sang_froid'],
                concentration: statsRow['concentration'],
                flair: statsRow['flair'],
                leadership: statsRow['leadership'],
              )
            : null;

        return {
          'name': joueur.nom,
          'position': joueur.postes.map((e) => e.name).toList(), // ✅ plusieurs postes
          'age': joueur.age,
          'rating': joueur.niveauActuel,
          'potentiel': joueur.potentiel,
          'value': '€${joueur.montantTransfert}M',
          'status': joueur.status.name,
          'stats': stats != null
              ? {
                  'marquage': stats.marquage,
                  'deplacement': stats.deplacement,
                  'frappes Lointaines': stats.frappesLointaines,
                  'passesLongues': stats.passesLongues,
                  'coupsFrancs': stats.coupsFrancs,
                  'tacles': stats.tacles,
                  'finition': stats.finition,
                  'centres': stats.centres,
                  'passes': stats.passes,
                  'corners': stats.corners,
                  'positionnement': stats.positionnement,
                  'dribble': stats.dribble,
                  'controle': stats.controle,
                  'penalties': stats.penalties,
                  'creativite': stats.creativite,
                  'stabilite Aerienne': stats.stabiliteAerienne,
                  'vitesse': stats.vitesse,
                  'endurance': stats.endurance,
                  'force': stats.force,
                  'distance Parcourue': stats.distanceParcourue,
                  'agressivite': stats.agressivite,
                  'sangFroid': stats.sangFroid,
                  'concentration': stats.concentration,
                  'flair': stats.flair,
                  'leadership': stats.leadership,
                }
              : {},
        };
      }).toList();

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
          onPressed: () => _showAddPlayerDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Ajouter'),
        ),
      ],
    );
  }

  void _showAddPlayerDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String nom = '';
    int age = 18;
    int niveauActuel = 60;
    int potentiel = 80;
    int montantTransfert = 1000000;
    StatusEnum status = StatusEnum.Titulaire;
    int dureeContrat = 3;
    int salaire = 10000;
    List<PosteEnum> postesSelectionnes = [];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Ajouter un joueur", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),

                    // Nom
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Nom"),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Nom obligatoire";
                        return null;
                      },
                      onSaved: (value) => nom = value!,
                    ),
                    const SizedBox(height: 12),

                    // Âge
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Âge"),
                      keyboardType: TextInputType.number,
                      initialValue: "18",
                      validator: (value) {
                        final v = int.tryParse(value ?? '');
                        if (v == null) return "Doit être un nombre";
                        if (v < 16) return "L'âge doit être ≥ 16";
                        return null;
                      },
                      onSaved: (value) => age = int.tryParse(value ?? "18") ?? 18,
                    ),
                    const SizedBox(height: 12),

                    // ✅ MultiSelect pour plusieurs postes
                   MultiSelectDialogField<PosteEnum>(
                      items: PosteEnum.values
                          .map((p) => MultiSelectItem<PosteEnum>(p, p.name))
                          .toList(),
                      title: Text(
                        "Postes",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      buttonText: Text(
                        "Choisir les postes",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      itemsTextStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      confirmText: Text(
                        "OK",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      cancelText: Text(
                        "Annuler",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      onConfirm: (values) {
                        postesSelectionnes = values;
                      },
                      validator: (values) {
                        if (values == null || values.isEmpty) return "Sélectionner au moins un poste";
                        return null;
                      },
                    ),

                    // Niveau actuel
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Niveau actuel"),
                      keyboardType: TextInputType.number,
                      initialValue: "60",
                      validator: (value) {
                        final v = int.tryParse(value ?? '');
                        if (v == null) return "Doit être un nombre";
                        if (v < 0 || v > 100) return "Doit être entre 0 et 100";
                        return null;
                      },
                      onSaved: (value) => niveauActuel = int.tryParse(value ?? "60") ?? 60,
                    ),
                    const SizedBox(height: 12),

                    // Potentiel
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Potentiel"),
                      keyboardType: TextInputType.number,
                      initialValue: "80",
                      validator: (value) {
                        final v = int.tryParse(value ?? '');
                        if (v == null) return "Doit être un nombre";
                        if (v < 0 || v > 100) return "Doit être entre 0 et 100";
                        return null;
                      },
                      onSaved: (value) => potentiel = int.tryParse(value ?? "80") ?? 80,
                    ),
                    const SizedBox(height: 12),

                    // Salaire
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Salaire"),
                      keyboardType: TextInputType.number,
                      initialValue: "10000",
                      onSaved: (value) => salaire = int.tryParse(value ?? "10000") ?? 10000,
                    ),
                    const SizedBox(height: 12),

                    // Statut
                    DropdownButtonFormField<StatusEnum>(
                      value: status,
                      decoration: const InputDecoration(labelText: "Statut"),
                      items: StatusEnum.values
                          .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                          .toList(),
                      onChanged: (value) => status = value!,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Annuler"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              // ✅ insertion dans Supabase avec plusieurs postes
                              final response = await Supabase.instance.client
                                .from('joueur_sm')
                                .insert({
                                  'nom': nom,
                                  'age': age,
                                  'postes': postesSelectionnes.map((p) => p.name).toList(),
                                  'niveau_actuel': niveauActuel,
                                  'potentiel': potentiel,
                                  'montant_transfert': montantTransfert,
                                  'status': status.name,
                                  'duree_contrat': dureeContrat,
                                  'salaire': salaire,
                                  'user_id': Supabase.instance.client.auth.currentUser!.id,
                                })
                                .select('id')
                                .single();

                              final joueurId = response['id'] != null ? response['id'] as int : null;

                              if (joueurId == null) {
                                print("Erreur: impossible de récupérer l'ID du joueur");
                                return;
                              }

                              final userId = Supabase.instance.client.auth.currentUser!.id;

                              // insérer des stats par défaut
                              await Supabase.instance.client.from('stats_joueur_sm').insert({
                                'user_id': userId,
                                'joueur_id': joueurId,
                                'marquage': 50,
                                'deplacement': 50,
                                'frappes_lointaines': 50,
                                'passes_longues': 50,
                                'coups_francs': 50,
                                'tacles': 50,
                                'finition': 50,
                                'centres': 50,
                                'passes': 50,
                                'corners': 50,
                                'positionnement': 50,
                                'dribble': 50,
                                'controle': 50,
                                'penalties': 50,
                                'creativite': 50,
                                'stabilite_aerienne': 50,
                                'vitesse': 50,
                                'endurance': 50,
                                'force': 50,
                                'distance_parcourue': 50,
                                'agressivite': 50,
                                'sang_froid': 50,
                                'concentration': 50,
                                'flair': 50,
                                'leadership': 50,
                              });

                              if (mounted) {
                                Navigator.pop(context);
                                fetchPlayers(); // rafraîchit la liste
                              }
                            }
                          },
                          child: const Text("Ajouter"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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