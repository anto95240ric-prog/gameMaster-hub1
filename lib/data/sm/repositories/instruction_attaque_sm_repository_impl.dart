import 'package:gamemaster_hub/domain/sm/entities/instruction_attaque_sm.dart';
import 'package:gamemaster_hub/domain/sm/repositories/instruction_attaque_sm_repository.dart';
import '../datasources/instruction_attaque_sm_remote_data_source.dart';
import '../models/instruction_attaque_sm_model.dart';

class InstructionAttaqueSmRepositoryImpl implements InstructionAttaqueSmRepository {
  final InstructionAttaqueSmRemoteDataSource remoteDataSource;

  InstructionAttaqueSmRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<InstructionAttaqueSm>> getAllInstructions() async {
    return await remoteDataSource.fetchInstructions();
  }

  @override
  Future<InstructionAttaqueSmModel> getInstructionByTactiqueId(int tactiqueId) async {
    final list = await remoteDataSource.fetchInstructions();
    return list.firstWhere(
      (i) => i.tactiqueId == tactiqueId,
      orElse: () => InstructionAttaqueSmModel(
        id: -1,
        tactiqueId: tactiqueId,
        stylePasse: '',
        styleAttaque: '',
        attaquants: '',
        jeuLarge: '',
        jeuConstruction: '',
        contreAttaque: '',
      ),
    );
  }

  @override
  Future<void> insertInstruction(InstructionAttaqueSm instruction) async {
    await remoteDataSource.insertInstruction(instruction as InstructionAttaqueSmModel);
  }

  @override
  Future<void> updateInstruction(InstructionAttaqueSm instruction) async {
    await remoteDataSource.updateInstruction(instruction as InstructionAttaqueSmModel);
  }

  @override
  Future<void> deleteInstruction(int id) async {
    await remoteDataSource.deleteInstruction(id);
  }
}
