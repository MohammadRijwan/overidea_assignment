import 'package:get_it/get_it.dart';
import 'package:overidea_assignment/src/feature/auth/data/auth_api_repo.dart';
import 'package:overidea_assignment/src/feature/chat/data/chat_repo.dart';
import 'package:overidea_assignment/src/feature/home/data/home_repo.dart';

void setupDependencies() {
  if (!GetIt.I.isRegistered<AuthApiRepo>()) {
    GetIt.instance.registerSingleton<AuthApiRepo>(AuthApiRepo());
  }
  if (!GetIt.I.isRegistered<HomeRepo>()) {
    GetIt.instance.registerSingleton<HomeRepo>(HomeRepo());
  }
  if (!GetIt.I.isRegistered<ChatRepo>()) {
    GetIt.instance.registerSingleton<ChatRepo>(ChatRepo());
  }
}
