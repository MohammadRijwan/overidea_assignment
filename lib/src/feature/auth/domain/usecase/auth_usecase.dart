import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';

import '../../data/auth_api_repo.dart';
import '../interface/i_auth_api_repo.dart';

class AuthUseCase {
  late IAuthApiRepo _authRepository;

  AuthUseCase({IAuthApiRepo? authRepository}) {
    _authRepository = authRepository ?? GetIt.instance.get<AuthApiRepo>();
  }

  Future<Either<Exception, String>> login(
      {required String email, required String password}) async {
    return await _authRepository.login(email: email, password: password);
  }

  Future<Either<Exception, String>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _authRepository.signUp(
        email: email, password: password, name: name);
  }

  // section  logout
  logout() async {
    await _authRepository.logout();
  }
}
