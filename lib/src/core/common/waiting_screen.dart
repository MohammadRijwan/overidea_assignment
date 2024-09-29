import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WaitingScreen {
  static void show(BuildContext context) {
    showDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (_) {
          return PopScope(
            canPop: false,
            child: Container(
              color: Colors.black12,
              child: const Center(
                  child: SpinKitCircle(
                color: Colors.white,
              )),
            ),
          );
        });
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
