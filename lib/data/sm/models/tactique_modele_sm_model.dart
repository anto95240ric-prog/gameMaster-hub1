import 'package:gamemaster_hub/domain/sm/entities/tactique_modele_sm.dart';

class TactiqueModeleSmModel extends TactiqueModeleSm {
  TactiqueModeleSmModel({
    required super.id,
    required super.formation,
    super.mentalite,
  });

  factory TactiqueModeleSmModel.fromMap(Map<String, dynamic> map) {
    return TactiqueModeleSmModel(
      id: map['id'],
      formation: map['formation'],
      mentalite: map['mentalite'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'formation': formation,
      'mentalite': mentalite,
    };
  }
}
