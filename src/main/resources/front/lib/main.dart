import 'package:flutter/material.dart';
import 'package:servelyzer/style/my_colors.dart';

import 'view/authorization_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SERVERYZER',
      theme: ThemeData(
        cursorColor: MyColors.green,
        primaryColor: MyColors.green,
        accentColor: MyColors.green,
        buttonColor: MyColors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthorizationPage(),
    );
  }
}
