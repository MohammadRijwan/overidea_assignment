import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:overidea_assignment/src/core/common/flutter_toast.dart';
import 'package:overidea_assignment/src/core/common/waiting_screen.dart';
import 'package:overidea_assignment/src/feature/home/ui/home_screen.dart';

import '../domain/usecase/auth_usecase.dart';

final singUpVmProvider = ChangeNotifierProvider.autoDispose<SignUpVm>((ref) {
  return SignUpVm();
});

class SignUpVm extends ChangeNotifier {
  late AuthUseCase _authUseCase;

  SignUpVm() {
    _authUseCase = AuthUseCase();
  }

  void onSignUp(
      String name, String email, String password, BuildContext context) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      FlutterToast.show(message: "All the fields are required.");
    } else {
      WaitingScreen.show(context);
      final result = await _authUseCase.signUp(
          email: email, password: password, name: name);
      result.fold((onLeft) {
        WaitingScreen.hide(context);
        FlutterToast.show(message: '$onLeft');
      }, (onRight) {
        WaitingScreen.hide(context);
        context.pushReplacementNamed(HomeScreen.route);
      });
    }
  }
}
