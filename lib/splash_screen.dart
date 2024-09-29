import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:overidea_assignment/src/core/utils/app_locale.dart';
import 'package:overidea_assignment/src/feature/auth/login/login_screen.dart';
import 'package:overidea_assignment/src/feature/home/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static String route = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    load();
    super.initState();
  }

  load() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await Future.delayed(const Duration(seconds: 1));
    if (_auth.currentUser != null) {
      context.pushReplacementNamed(HomeScreen.route);
    } else {
      context.goNamed(LoginScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              AppLocale.welcome.getString(context),
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
