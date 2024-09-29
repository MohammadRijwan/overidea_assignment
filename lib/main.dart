import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overidea_assignment/src/core/dependency/dependency_injection.dart';
import 'package:overidea_assignment/src/core/utils/app_constant.dart';
import 'package:overidea_assignment/src/core/utils/app_locale.dart';
import 'package:overidea_assignment/src/core/utils/app_router.dart';
import 'package:overidea_assignment/src/core/utils/notification_service.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('123456'), //this line was commented out
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );
  setupDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  _setPhoneInPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _setTabletInLandScapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void initState() {
    _localization.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'ar',
          AppLocale.AR,
          countryCode: 'AR',
          fontFamily: 'Font EN',
        ),
      ],
      initLanguageCode: 'en',
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    _localization.translate('en');
    NotificationService().initialise();
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      Size size;
      if (constraints.maxHeight >= 500 && constraints.maxWidth >= 550) {
        _setTabletInLandScapeMode();
        size = const Size(900, 690);
        AppConstant.isWeb = true;
      } else {
        _setPhoneInPortraitMode();
        size = const Size(360, 690);
      }
      return ScreenUtilInit(
          designSize: size,
          minTextAdapt: true,
          splitScreenMode: true,
          ensureScreenSize: true,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: MaterialApp.router(
                routerConfig: AppRoute.router,
                title: 'Overidea Assignment',
                supportedLocales: _localization.supportedLocales,
                localizationsDelegates: _localization.localizationsDelegates,
              ),
            );
          });
    });
  }
}
