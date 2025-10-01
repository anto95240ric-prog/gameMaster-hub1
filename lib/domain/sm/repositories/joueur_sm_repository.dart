import '../entities/joueur_sm.dart';

abstract class JoueurSmRepository {
  Future<List<JoueurSm>> getAllJoueurs();
  Future<JoueurSm> getJoueurById(int id);
  Future<void> insertJoueur(JoueurSm joueur);
  Future<void> updateJoueur(JoueurSm joueur);
  Future<void> deleteJoueur(int id);
}
