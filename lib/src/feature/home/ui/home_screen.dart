import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:overidea_assignment/src/core/utils/app_constant.dart';
import 'package:overidea_assignment/src/core/utils/app_locale.dart';
import 'package:overidea_assignment/src/feature/auth/domain/model/user.dart';
import 'package:overidea_assignment/src/feature/auth/login/login_screen.dart';
import 'package:overidea_assignment/src/feature/chat/ui/chat_screen.dart';
import 'package:overidea_assignment/src/feature/map/map_screen.dart';

import 'home_vm.dart';

class HomeScreen extends StatefulWidget {
  static String route = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer(builder: (context, ref, _) {
      final _vm = ref.watch(homeVmProvider);
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocale.home.getString(context),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  )),
        ),
        drawer: Drawer(
          backgroundColor: Theme.of(context).primaryColor,
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person_2_rounded,
                  size: 45.0,
                  color: Colors.white,
                ),
                title: Text(
                  FirebaseAuth.instance.currentUser?.email ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  FirebaseAuth.instance.currentUser?.email ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 60.0),
              ListTile(
                enabled: true,
                shape: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
                leading: const Icon(
                  Icons.map,
                  color: Colors.white,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
                onTap: () {
                  context.pop();
                  context.pushNamed(MapScreen.route);
                },
                title: Text(
                  AppLocale.map.getString(context),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                enabled: true,
                shape: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
                leading: const Icon(
                  Icons.language_rounded,
                  color: Colors.white,
                ),
                trailing: Switch(
                    activeColor: Theme.of(context).secondaryHeaderColor,
                    value: _localization.currentLocale?.languageCode == 'en'
                        ? true
                        : false,
                    onChanged: (value) {
                      _localization.currentLocale?.languageCode == 'en'
                          ? _localization.translate('ar')
                          : _localization.translate('en');
                    }),
                title: Text(
                  AppLocale.language.getString(context),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                  shape: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: Text(
                    AppLocale.logout.getString(context),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            AppLocale.logout.getString(context),
                          ),
                          content:
                              Text(AppLocale.logoutContent.getString(context)),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  context.goNamed(LoginScreen.route);
                                },
                                child: Text(
                                  AppLocale.yes.getString(context),
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  AppLocale.no.getString(context),
                                )),
                          ],
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
        body: StreamBuilder(
            stream: _vm.fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * (AppConstant.isWeb ? 0.2 : 0.0)),
                itemBuilder: (context, index) {
                  final user = snapshot.data!.docs[index];
                  final UserModel userModel = UserModel(
                      name: user['name'],
                      email: user['email'],
                      registerDate: user['registerDate'],
                      userId: user['userId']);
                  if (user['userId'] ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    return const SizedBox();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Theme.of(context).secondaryHeaderColor,
                        child: ListTile(
                          onTap: () {
                            context.pushNamed(ChatScreen.route,
                                extra: userModel);
                          },
                          title: Text(userModel.name),
                          subtitle: Text(userModel.email),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    );
                  }
                },
              );
            }),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     context.pushNamed(MapScreen.route);
        //   },
        //   child: const Icon(Icons.map_rounded),
        // ),
      );
    });
  }
}
