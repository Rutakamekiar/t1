import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:servelyzer/bloc/authorization_bloc.dart';
import 'package:servelyzer/model/auth_model.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/style/route_transition_styles.dart';
import 'package:servelyzer/view/main_page.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:servelyzer/widget/base_text_field.dart';
import 'package:servelyzer/widget/my_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    authorizationBloc.auth.listen((event) {
      setLoading(false);
      if(event){
        openMainPage();
      } else {
        showInformDialog("Неправильний логін або пароль");
      }
    }, onError: (e){
      setLoading(false);
      showInformDialog("Неправильний логін або пароль");
      // showInformDialog("Сталася помилка $e");
    });
    loginController.addListener(() {
      setLoginError(false);
    });
    passwordController.addListener(() {
      setPasswordError(false);
    });
  }

  showInformDialog(String text, {String button = "Ок"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog.information(
        content: text,
        button: button,
        onPositive: () {
          Navigator.pop(context);
        },
      ),
    );
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
      AuthModel authModel = AuthModel(loginController.text, passwordController.text);
      authorizationBloc.authFetcher(authModel);
    }
  }

  openMainPage() {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
            transitionsBuilder: RouteTransitionStyles.defaultStyle));
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
    const url = 'https://www.termsandconditionsgenerator.com/live.php?token=inVvQirGrjE9dMBdd5PH5Mtnxevc2fRw';
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
                constraints: BoxConstraints(maxWidth: 516, maxHeight: 473),
                height: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    AutoSizeText(
                      "Добро пожаловать",
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
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              alignment: Alignment.center,
              child: FlatButton(
                onPressed: _launchURL,
                child: Text("Terms and Conditions", style: TextStyle(color: MyColors.green),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
