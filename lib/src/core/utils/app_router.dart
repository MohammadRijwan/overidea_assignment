import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overidea_assignment/splash_screen.dart';
import 'package:overidea_assignment/src/feature/auth/domain/model/user.dart';
import 'package:overidea_assignment/src/feature/auth/registration/signup_screen.dart';
import 'package:overidea_assignment/src/feature/home/ui/home_screen.dart';
import 'package:overidea_assignment/src/feature/map/map_screen.dart';

import '../../feature/auth/login/login_screen.dart';
import '../../feature/chat/ui/chat_screen.dart';

class AppRoute {
  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      getAllRoutes(),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        RouteErrorScreen(
            title: 'Route Not Found',
            message: 'Error! The route ${state.error} not found.'),
  );

  static GoRouter get router => _router;

  static GoRoute getAllRoutes() {
    return GoRoute(
        path: SplashScreen.route,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
        routes: <RouteBase>[
          getLoginRoute(),
          getSignUpRoute(),
          getHomeRoute(),
          getMapRoute(),
          getChatRoute(),
        ]);
  }

  static GoRoute getLoginRoute() {
    return GoRoute(
        path: LoginScreen.route,
        name: LoginScreen.route,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen());
  }

  static GoRoute getSignUpRoute() {
    return GoRoute(
        path: SignUpScreen.route,
        name: SignUpScreen.route,
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpScreen());
  }

  static GoRoute getHomeRoute() {
    return GoRoute(
        path: HomeScreen.route,
        name: HomeScreen.route,
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen());
  }

  static GoRoute getMapRoute() {
    return GoRoute(
        path: MapScreen.route,
        name: MapScreen.route,
        builder: (BuildContext context, GoRouterState state) =>
            const MapScreen());
  }

  static GoRoute getChatRoute() {
    return GoRoute(
        path: ChatScreen.route,
        name: ChatScreen.route,
        builder: (BuildContext context, GoRouterState state) =>
            ChatScreen(receiverUser: state.extra as UserModel));
  }
}

class RouteErrorScreen extends StatelessWidget {
  final String title;
  final String message;

  const RouteErrorScreen(
      {super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 30.0),
        ),
      ),
    );
  }
}
