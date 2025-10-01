import 'package:gamemaster_hub/domain/sm/entities/role_modele_sm.dart';

class RoleModeleSmModel extends RoleModeleSm {
  RoleModeleSmModel({
    required super.id,
    required super.poste,
    required super.role,
    super.description,
  });

  factory RoleModeleSmModel.fromMap(Map<String, dynamic> map) {
    return RoleModeleSmModel(
      id: map['id'],
      poste: map['poste'],
      role: map['role'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'poste': poste,
      'role': role,
      'description': description,
    };
  }
}
