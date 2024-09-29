import 'package:fpdart/fpdart.dart';
import 'package:overidea_assignment/src/core/data/remote/firebase_db.dart';
import 'package:overidea_assignment/src/core/domain/datasource/i_db.dart';

import '../domain/interface/i_auth_api_repo.dart';

class AuthApiRepo implements IAuthApiRepo {
  late IDb _database;

  AuthApiRepo({IDb? database}) {
    _database = database ?? FirebaseDb();
  }

  @override
  Future<Either<Exception, String>> login(
      {required String email, required String password}) async {
    return await _database.login(email: email, password: password);
  }

  //section signup
  @override
  Future<Either<Exception, String>> signUp(
      {required String email,
      required String password,
      required String name}) async {
    return await _database.signUp(email: email, password: password, name: name);
  }

  //logout
  @override
  Future<void> logout() async {
    await _database.logout();
  }
}
