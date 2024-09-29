import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overidea_assignment/src/feature/auth/domain/model/user.dart';
import 'package:overidea_assignment/src/feature/home/domain/usecase/home_usecase.dart';

final homeVmProvider = ChangeNotifierProvider.autoDispose<HomeVm>((ref) {
  return HomeVm();
});

class HomeVm extends ChangeNotifier {
  late HomeUseCase _homeUseCase;
  bool isLoading = true;

  List<UserModel> users = [];

  HomeVm() {
    _homeUseCase = HomeUseCase();
  }

  Stream<QuerySnapshot> fetchUsers() {
    return _homeUseCase.fetchUsers();
  }
}
