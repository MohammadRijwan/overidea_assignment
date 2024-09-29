import 'package:fpdart/fpdart.dart';

abstract class IAuthApiRepo {
  Future<Either<Exception, String>> login({
    required String email,
    required String password,
  });

  Future<Either<Exception, String>> signUp({
    required String email,
    required String password,
    required String name,
  });
  Future<void> logout();
}
