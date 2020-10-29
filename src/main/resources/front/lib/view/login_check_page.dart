import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:servelyzer/bloc/login_check_bloc.dart';
import 'package:servelyzer/style/my_colors.dart';

class LoginCheckPage extends StatefulWidget {
  @override
  _LoginCheckPageState createState() => _LoginCheckPageState();
}

class _LoginCheckPageState extends State<LoginCheckPage> {
  final loginCheckBloc = LoginCheckBloc();

  @override
  void initState() {
    super.initState();
    loginCheckBloc.loginFetcher();
    loginCheckBloc.login.listen((event) {
      if (event.result == 1) {
        Modular.to.pushReplacementNamed('/main');
      } else {
        Modular.to.pushReplacementNamed('/auth');
      }
    }, onError: (e) {
      Modular.to.pushReplacementNamed('/auth');
    });
  }

  @override
  void dispose() {
    loginCheckBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
