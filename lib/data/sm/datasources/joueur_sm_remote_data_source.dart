import '../models/joueur_sm_model.dart';

abstract class JoueurSmRemoteDataSource {
  Future<List<JoueurSmModel>> fetchJoueurs();
  Future<void> insertJoueur(JoueurSmModel joueur);
  Future<void> updateJoueur(JoueurSmModel joueur);
  Future<void> deleteJoueur(int id);
}

// Exemple d'implémentation factice
class JoueurSmRemoteDataSourceImpl implements JoueurSmRemoteDataSource {
  final List<JoueurSmModel> _fakeDb = [];

  @override
  Future<List<JoueurSmModel>> fetchJoueurs() async {
    return _fakeDb;
  }

  @override
  Future<void> insertJoueur(JoueurSmModel joueur) async {
    _fakeDb.add(joueur);
  }

  @override
  Future<void> updateJoueur(JoueurSmModel joueur) async {
    final index = _fakeDb.indexWhere((j) => j.id == joueur.id);
    if (index != -1) {
      _fakeDb[index] = joueur;
    }
  }

  @override
  Future<void> deleteJoueur(int id) async {
    _fakeDb.removeWhere((j) => j.id == id);
  }
}
