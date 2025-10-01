import '../entities/instruction_general_sm.dart';

abstract class InstructionGeneralSmRepository {
  Future<List<InstructionGeneralSm>> getAllInstructions();
  Future<InstructionGeneralSm?> getInstructionByTactiqueId(int tactiqueId);
  Future<void> insertInstruction(InstructionGeneralSm instruction);
  Future<void> updateInstruction(InstructionGeneralSm instruction);
  Future<void> deleteInstruction(int id);
}
