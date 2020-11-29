import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
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
      if (event != null) {
        if (event.result == 1) {
          openMainPage();
        } else {
          DialogHelper.showInformDialog(context, tr("invalid_login_password"),
              button: tr("ok"), onPositive: () => Navigator.pop(context));
        }
      } else {
        DialogHelper.showInformDialog(context, tr("user_not_activated"),
            button: tr("ok"), onPositive: () => Navigator.pop(context));
      }
    }, onError: (e) {
      setLoading(false);
      DialogHelper.showInformDialog(
          context, tr("error_occurred", args: [e.toString()]),
          button: tr("ok"), onPositive: () => Navigator.pop(context));
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
            Container(
              alignment: Alignment.center,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 516),
                alignment: Alignment.centerRight,
                child: DropdownButton<Locale>(
                  value: context.locale,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  iconEnabledColor: MyColors.green,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  underline: Container(
                    height: 0,
                    padding: EdgeInsets.only(top: 5),
                    color: MyColors.green,
                  ),
                  onChanged: (Locale newValue) {
                    print(newValue);
                    context.locale = newValue;
                  },
                  items: <Locale>[Locale("en"), Locale("uk")]
                      .map<DropdownMenuItem<Locale>>((Locale value) {

                    String name = "En";
                    String image = "united-kingdom.png";
                    if(value.languageCode == "uk"){
                      name = "Укр";
                      image = "ukraine.png";
                    }

                    return DropdownMenuItem<Locale>(
                      value: value,
                      child: Row(
                        children: [
                          Image.asset("assets/$image", width: 20, height: 20,),
                          SizedBox(width: 5,),
                          Text(name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
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
                      tr("welcome"),
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
                          label: tr("login"),
                          errorText: tr("enter_login")),
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
                        label: tr("password"),
                        errorText: tr("enter_password"),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    BaseButton(
                      isLoading: isLoading,
                      title: tr("enter"),
                      onPressed: checkFields,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FlatButton(
                      onPressed: openRegistrationPage,
                      child: Text(
                        tr("register"),
                        style: TextStyle(color: MyColors.green),
                      ),
                    ),
                    FlatButton(
                      onPressed: openResetPasswordPage,
                      child: Text(
                        tr("forgot_password"),
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
                  tr("terms_and_conditions"),
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
