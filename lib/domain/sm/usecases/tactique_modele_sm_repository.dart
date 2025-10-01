import '../entities/tactique_modele_sm.dart';

abstract class TactiqueModeleSmRepository {
  Future<List<TactiqueModeleSm>> getAllTactiques();
  Future<TactiqueModeleSm?> getTactiqueById(int id);
  Future<void> insertTactique(TactiqueModeleSm tactique);
  Future<void> updateTactique(TactiqueModeleSm tactique);
  Future<void> deleteTactique(int id);
}
