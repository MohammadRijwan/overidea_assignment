import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:overidea_assignment/src/core/data/remote/firebase_db.dart';
import 'package:overidea_assignment/src/core/domain/datasource/i_db.dart';
import 'package:overidea_assignment/src/feature/home/domain/interface/i_home_repo.dart';

class HomeRepo implements IHomeRepo {
  late IDb _database;

  HomeRepo({IDb? database}) {
    _database = database ?? FirebaseDb();
  }

  @override
  Stream<QuerySnapshot> fetchUsers() {
    return _database.fetchUsers();
  }

  @override
  Future<Either<Exception, bool>> storeFcm() {
    return _database.storeFcm();
  }
}
