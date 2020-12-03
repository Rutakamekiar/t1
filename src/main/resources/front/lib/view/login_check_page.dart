import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:servelyzer/bloc/login_check_bloc.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/style/my_colors.dart';
const int version = 1;

class LoginCheckPage extends StatefulWidget {
  @override
  _LoginCheckPageState createState() => _LoginCheckPageState();
}

class _LoginCheckPageState extends State<LoginCheckPage> {
  final _loginCheckBloc = LoginCheckBloc();

  @override
  void initState() {
    super.initState();
    print(version);
    _loginCheckBloc.loginFetcher();
    _loginCheckBloc.login.listen(_checkUser, onError: (e) {
      // Modular.to.pushReplacementNamed('/admin');
      Modular.to.pushReplacementNamed('/auth');
    });
  }

  void _checkUser(ResponseModel response) {
    if (response.result == 1) {
      if (response.userStatus == "admin") {
        Modular.to.pushReplacementNamed('/admin');
      } else {
        Modular.to.pushReplacementNamed('/main');
      }
    } else {
      Modular.to.pushReplacementNamed('/auth');
    }
  }

  @override
  void dispose() {
    _loginCheckBloc.dispose();
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
