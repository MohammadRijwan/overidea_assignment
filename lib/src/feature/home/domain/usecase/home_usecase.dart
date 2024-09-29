import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:overidea_assignment/src/feature/home/data/home_repo.dart';
import 'package:overidea_assignment/src/feature/home/domain/interface/i_home_repo.dart';

class HomeUseCase {
  late IHomeRepo _homeRepository;

  HomeUseCase({IHomeRepo? authRepository}) {
    _homeRepository = authRepository ?? GetIt.instance.get<HomeRepo>();
    storeFcm();
  }

  Stream<QuerySnapshot> fetchUsers() {
    return _homeRepository.fetchUsers();
  }

  Future<Either<Exception, bool>> storeFcm() async {
    return await _homeRepository.storeFcm();
  }
}
