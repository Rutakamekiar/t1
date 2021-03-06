import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/view/admin_page.dart';
import 'package:servelyzer/view/email_verified_page.dart';
import 'package:servelyzer/view/login_check_page.dart';
import 'package:servelyzer/view/main_page.dart';
import 'package:servelyzer/view/registration_page.dart';
import 'package:servelyzer/view/reset_password_page.dart';

import 'view/authorization_page.dart';

void main() {
  runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('uk')],
      fallbackLocale: Locale('en'),
      path: 'assets/translations',
      child: ModularApp(module: AppModule())));
}

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter('/', child: (_, __) => LoginCheckPage()),
        ModularRouter('/auth', child: (_, __) => AuthorizationPage()),
        ModularRouter('/main', child: (_, __) => MainPage()),
        ModularRouter('/verification', child: (_, __) => EmailVerifiedPage()),
        ModularRouter('/registration', child: (_, __) => RegistrationPage()),
        ModularRouter('/reset', child: (_, __) => ResetPasswordPage()),
        ModularRouter('/admin', child: (_, __) => AdminPage()),
      ];

  @override
  Widget get bootstrap => MyApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'SERVERYZER',
      theme: ThemeData(
        primaryColor: MyColors.green,
        accentColor: MyColors.green,
        buttonColor: MyColors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      navigatorKey: Modular.navigatorKey,
      onGenerateRoute: Modular.generateRoute,
    );
  }
}
