import 'package:gamemaster_hub/domain/sm/entities/instruction_defense_sm.dart';

class InstructionDefenseSmModel extends InstructionDefenseSm {
  InstructionDefenseSmModel({
    required super.id,
    required super.tactiqueId,
    super.pressing,
    super.styleTacle,
    super.ligneDefensive,
    super.gardienLibero,
    super.perteTemps,
  });

  factory InstructionDefenseSmModel.fromMap(Map<String, dynamic> map) {
    return InstructionDefenseSmModel(
      id: map['id'],
      tactiqueId: map['tactique_id'],
      pressing: map['pressing'],
      styleTacle: map['style_tacle'],
      ligneDefensive: map['ligne_defensive'],
      gardienLibero: map['gardien_libero'],
      perteTemps: map['perte_temps'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tactique_id': tactiqueId,
      'pressing': pressing,
      'style_tacle': styleTacle,
      'ligne_defensive': ligneDefensive,
      'gardien_libero': gardienLibero,
      'perte_temps': perteTemps,
    };
  }
}
