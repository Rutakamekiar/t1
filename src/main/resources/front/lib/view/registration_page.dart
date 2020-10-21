import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:servelyzer/bloc/registration_bloc.dart';
import 'package:servelyzer/model/registration_model.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:servelyzer/widget/base_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool loginError = false;
  bool emailError = false;
  bool passwordError = false;
  bool confirmPasswordError = false;

  String confirmPasswordErrorMessage = "Введіть пароль ще раз";
  String passwordErrorMessage = "Введіть пароль";
  String emailErrorMessage = "Введіть e-mail";

  bool isLoading = false;

  final registrationBloc = RegistrationBloc();

  @override
  void initState() {
    super.initState();
    registrationBloc.registration.listen((event) {
      print(event);
      setLoading(false);
      if (event) {
        openMainPage();
      } else {
        // showInformDialog("Неправильний логін або пароль");
      }
    }, onError: (e) {
      setLoading(false);
      print(e);
      // showInformDialog("Неправильний логін або пароль");
    });
    loginController.addListener(() {
      setLoginError(false);
    });
    emailController.addListener(() {
      if(!EmailValidator.validate(emailController.text) && emailController.text.isNotEmpty){
        setState(() {
          emailErrorMessage = "Невірний формат";
        });
        setEmailError(true);
      } else {
        setEmailError(false);
      }
    });
    passwordController.addListener(() {
      setPasswordError(false);
    });
    confirmPasswordController.addListener(() {
      setConfirmPasswordError(false);
    });
  }

  @override
  void dispose() {
    loginController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    registrationBloc.dispose();
    super.dispose();
  }

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  setPasswordError(bool state) {
    if (passwordError != state) {
      setState(() {
        passwordError = state;
      });
    }
  }

  setConfirmPasswordError(bool state) {
    if (confirmPasswordError != state) {
      setState(() {
        confirmPasswordError = state;
      });
    }
  }

  setEmailError(bool state) {
    if (emailError != state) {
      setState(() {
        emailError = state;
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

  checkFields() {
    bool isValid = true;
    if (loginController.text.isEmpty) {
      setLoginError(true);
      isValid = false;
    }
    if (emailController.text.isEmpty) {
      setState(() {
        emailErrorMessage = "Введіть e-mail";
      });
      setEmailError(true);
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      setPasswordError(true);
      isValid = false;
    }
    if (confirmPasswordController.text.isEmpty) {
      setState(() {
        confirmPasswordErrorMessage = "Введіть пароль ще раз";
      });
      setConfirmPasswordError(true);
      isValid = false;
    }
    if(emailController.text.isNotEmpty && !EmailValidator.validate(emailController.text)){
      setState(() {
        emailErrorMessage = "Невірний формат";
      });
      setEmailError(true);
      isValid = false;
    }
    if (confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text != passwordController.text &&
        passwordController.text.isNotEmpty) {
      setState(() {
        confirmPasswordErrorMessage = "Паролі не спідвпадають";
      });
      setConfirmPasswordError(true);
      isValid = false;
    }

    if (isValid) {
      setLoading(true);
      RegistrationModel registrationModel =
      RegistrationModel(loginController.text, emailController.text, passwordController.text);
      registrationBloc.registrationFetcher(registrationModel);
    }
  }

  openMainPage() {
    Modular.to.pushReplacementNamed('/main');
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
                      "Реєстрація",
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
                          isError: loginError,
                          textEditingController: loginController,
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
                          textEditingController: emailController,
                          isError: emailError,
                          enable: !isLoading,
                          onSubmitted: (value) => checkFields(),
                          label: "E-mail",
                          errorText: emailErrorMessage),
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
                        errorText: passwordErrorMessage,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 318),
                      child: BaseTextField(
                        obscureText: true,
                        textEditingController: confirmPasswordController,
                        isError: confirmPasswordError,
                        onSubmitted: (value) => checkFields(),
                        enable: !isLoading,
                        label: "Підтвердження пароля",
                        errorText: confirmPasswordErrorMessage,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    BaseButton(
                      isLoading: isLoading,
                      title: "Зареєструватися",
                      onPressed: checkFields,
                    ),
                    SizedBox(
                      height: 40,
                    ),
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
