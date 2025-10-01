import 'package:gamemaster_hub/domain/sm/entities/tactique_modele_sm.dart';
import 'package:gamemaster_hub/domain/sm/repositories/tactique_modele_sm_repository.dart';
import '../datasources/tactique_modele_sm_remote_data_source.dart';
import '../models/tactique_modele_sm_model.dart';

class TactiqueModeleSmRepositoryImpl implements TactiqueModeleSmRepository {
  final TactiqueModeleSmRemoteDataSource remoteDataSource;

  TactiqueModeleSmRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TactiqueModeleSm>> getAllTactiques() async {
    return await remoteDataSource.fetchTactiques();
  }

  @override
  Future<TactiqueModeleSmModel> getTactiqueById(int id) async {
    final tactiques = await remoteDataSource.fetchTactiques();
    return tactiques.firstWhere(
      (t) => t.id == id,
      orElse: () => TactiqueModeleSmModel(
        id: -1,
        formation: '',
        mentalite: ''
      ),
    );
  }


  @override
  Future<void> insertTactique(TactiqueModeleSm tactique) async {
    await remoteDataSource.insertTactique(tactique as TactiqueModeleSmModel);
  }

  @override
  Future<void> updateTactique(TactiqueModeleSm tactique) async {
    await remoteDataSource.updateTactique(tactique as TactiqueModeleSmModel);
  }

  @override
  Future<void> deleteTactique(int id) async {
    await remoteDataSource.deleteTactique(id);
  }
}
