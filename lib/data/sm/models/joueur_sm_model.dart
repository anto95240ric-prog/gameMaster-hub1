import 'package:gamemaster_hub/domain/common/enums.dart';
import 'package:gamemaster_hub/domain/sm/entities/joueur_sm.dart';

class JoueurSmModel {
  final int id;
  final String nom;
  final int age;
  final PosteEnum poste;
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
    required this.poste,
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
      poste: poste,
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
      poste: joueur.poste,
      niveauActuel: joueur.niveauActuel,
      potentiel: joueur.potentiel,
      montantTransfert: joueur.montantTransfert,
      status: joueur.status,
      dureeContrat: joueur.dureeContrat,
      salaire: joueur.salaire,
      userId: joueur.userId,
    );
  }
}
