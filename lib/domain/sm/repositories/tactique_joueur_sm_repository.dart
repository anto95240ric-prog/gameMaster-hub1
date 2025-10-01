import '../entities/tactique_joueur_sm.dart';

abstract class TactiqueJoueurSmRepository {
  Future<List<TactiqueJoueurSm>> getAll();
  Future<List<TactiqueJoueurSm>> getByTactiqueId(int tactiqueId);
  Future<void> insert(TactiqueJoueurSm tj);
  Future<void> update(TactiqueJoueurSm tj);
  Future<void> delete(int id);
}
