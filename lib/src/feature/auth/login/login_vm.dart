import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:overidea_assignment/src/core/common/flutter_toast.dart';
import 'package:overidea_assignment/src/core/common/waiting_screen.dart';
import 'package:overidea_assignment/src/feature/auth/domain/usecase/auth_usecase.dart';
import 'package:overidea_assignment/src/feature/home/ui/home_screen.dart';

final loginVmProvider = ChangeNotifierProvider.autoDispose<LoginVm>((ref) {
  return LoginVm();
});

class LoginVm extends ChangeNotifier {
  late AuthUseCase _authUseCase;

  LoginVm() {
    _authUseCase = AuthUseCase();
  }

  void onLogin(String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      FlutterToast.show(message: "All the fields are required.");
    } else {
      WaitingScreen.show(context);
      final result = await _authUseCase.login(email: email, password: password);
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
