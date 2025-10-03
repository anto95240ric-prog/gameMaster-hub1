import 'package:gamemaster_hub/domain/common/enums.dart';
import 'package:gamemaster_hub/domain/sm/entities/joueur_sm.dart';

class JoueurSmModel {
  final int id;
  final String nom;
  final int age;
  final List<PosteEnum> postes;
  final int niveauActuel;
  final int potentiel;
  final int montantTransfert;
  final StatusEnum status;
  final int dureeContrat;
  final int salaire;
  final String userId;

  JoueurSmModel({
    required this.id,
    required this.nom,
    required this.age,
    required this.postes,
    required this.niveauActuel,
    required this.potentiel,
    required this.montantTransfert,
    required this.status,
    required this.dureeContrat,
    required this.salaire,
    required this.userId,
  });

  /// 🔹 Conversion vers l'entité (domain)
  JoueurSm toEntity() {
    return JoueurSm(
      id: id,
      nom: nom,
      age: age,
      postes: postes,
      niveauActuel: niveauActuel,
      potentiel: potentiel,
      montantTransfert: montantTransfert,
      status: status,
      dureeContrat: dureeContrat,
      salaire: salaire,
      userId: userId,
    );
  }

  /// 🔹 Conversion depuis l'entité (utile pour insert/update)
  factory JoueurSmModel.fromEntity(JoueurSm joueur) {
    return JoueurSmModel(
      id: joueur.id,
      nom: joueur.nom,
      age: joueur.age,
      postes: joueur.postes,
      niveauActuel: joueur.niveauActuel,
      potentiel: joueur.potentiel,
      montantTransfert: joueur.montantTransfert,
      status: joueur.status,
      dureeContrat: joueur.dureeContrat,
      salaire: joueur.salaire,
      userId: joueur.userId,
    );
  }

  /// 🔹 Conversion depuis une Map (Supabase)
  factory JoueurSmModel.fromMap(Map<String, dynamic> map) {
    return JoueurSmModel(
      id: map['id'],
      nom: map['nom'],
      age: map['age'],
      postes: (map['postes'] as List<dynamic>)
          .map((p) => PosteEnum.values.firstWhere((e) => e.name == p))
          .toList(),
      niveauActuel: map['niveau_actuel'],
      potentiel: map['potentiel'],
      montantTransfert: map['montant_transfert'],
      status: StatusEnum.values.firstWhere((e) => e.name == map['status']),
      dureeContrat: map['duree_contrat'],
      salaire: map['salaire'],
      userId: map['user_id'],
    );
  }

  /// 🔹 Conversion vers une Map (Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'age': age,
      'postes': postes.map((p) => p.name).toList(),
      'niveau_actuel': niveauActuel,
      'potentiel': potentiel,
      'montant_transfert': montantTransfert,
      'status': status.name,
      'duree_contrat': dureeContrat,
      'salaire': salaire,
      'user_id': userId,
    };
  }
}
