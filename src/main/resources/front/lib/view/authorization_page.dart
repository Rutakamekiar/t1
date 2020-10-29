import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:servelyzer/bloc/authorization_bloc.dart';
import 'package:servelyzer/model/auth_model.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/utils/constants.dart';
import 'package:servelyzer/utils/dialog_helper.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:servelyzer/widget/base_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorizationPage extends StatefulWidget {
  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loginError = false;
  bool passwordError = false;
  bool isLoading = false;

  final authorizationBloc = AuthorizationBloc();

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<String> loadAsset(BuildContext context) async {
    return await DefaultAssetBundle.of(context).loadString('assets/host.txt');
  }

  @override
  void initState() {
    super.initState();
    loadAsset(context).then((value) {
      Constants.url = value;
      print(Constants.url);
    });
    authorizationBloc.auth.listen((event) {
      setLoading(false);
      if (event) {
        openMainPage();
      } else {
        DialogHelper.showInformDialog(context, "Неправильний логін або пароль", onPositive: ()=> Navigator.pop(context));
      }
    }, onError: (e) {
      setLoading(false);
      DialogHelper.showInformDialog(context, "Неправильний логін або пароль", onPositive: ()=> Navigator.pop(context));
    });
    loginController.addListener(() {
      setLoginError(false);
    });
    passwordController.addListener(() {
      setPasswordError(false);
    });
  }

  checkFields() {
    bool isValid = true;
    if (loginController.text.isEmpty) {
      setLoginError(true);
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      setPasswordError(true);
      isValid = false;
    }
    if (isValid) {
      setLoading(true);
      AuthModel authModel =
          AuthModel(loginController.text, passwordController.text);
      authorizationBloc.authFetcher(authModel);
    }
  }

  openMainPage() {
    Modular.to.pushReplacementNamed('/main');
  }

  openRegistrationPage() {
    Modular.to.pushNamed('/registration');
  }

  openResetPasswordPage() {
    Modular.to.pushNamed('/reset');
  }

  setPasswordError(bool state) {
    if (passwordError != state) {
      setState(() {
        passwordError = state;
      });
    }
  }

  setLoginError(bool state) {
    if (loginError != state) {
      setState(() {
        loginError = state;
      });
    }
  }

  @override
  void dispose() {
    authorizationBloc.dispose();
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _launchURL() async {
    const url =
        'https://www.termsandconditionsgenerator.com/live.php?token=inVvQirGrjE9dMBdd5PH5Mtnxevc2fRw';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: <Widget>[
            Image.asset(
              "assets/logo.png",
              height: 90,
            ),
            SizedBox(
              height: 72,
            ),
            Container(
              alignment: Alignment.center,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(232, 228, 228, 0.5),
                          offset: Offset(0, 14),
                          blurRadius: 23)
                    ]),
                constraints: BoxConstraints(maxWidth: 516),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    AutoSizeText(
                      "Ласкаво просимо",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 24),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 318),
                      child: BaseTextField(
                          textEditingController: loginController,
                          isError: loginError,
                          enable: !isLoading,
                          onSubmitted: (value) => checkFields(),
                          label: "Логін",
                          errorText: "Введіть логін"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 318),
                      child: BaseTextField(
                        textEditingController: passwordController,
                        isError: passwordError,
                        obscureText: true,
                        onSubmitted: (value) => checkFields(),
                        enable: !isLoading,
                        label: "Пароль",
                        errorText: "Введіть пароль",
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    BaseButton(
                      isLoading: isLoading,
                      onPressed: checkFields,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FlatButton(
                      onPressed: openRegistrationPage,
                      child: Text(
                        "Зареєструватися",
                        style: TextStyle(color: MyColors.green),
                      ),
                    ),
                    FlatButton(
                      onPressed: openResetPasswordPage,
                      child: Text(
                        "Забув пароль",
                        style: TextStyle(color: MyColors.green),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: FlatButton(
                onPressed: _launchURL,
                child: Text(
                  "Terms and Conditions",
                  style: TextStyle(color: MyColors.green),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
