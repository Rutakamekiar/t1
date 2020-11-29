import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:servelyzer/bloc/registration_bloc.dart';
import 'package:servelyzer/model/registration_model.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/utils/dialog_helper.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:servelyzer/widget/base_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

const int minPasswordLength = 8;

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

  String confirmPasswordErrorMessage = tr("enter_password_again");
  String passwordErrorMessage = tr("enter_password");
  String emailErrorMessage = tr("enter_email");

  bool isLoading = false;

  final registrationBloc = RegistrationBloc();

  openAuthPage() {
    Modular.to.pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  void initState() {
    super.initState();
    registrationBloc.registration.listen((responseModel) {
      setLoading(false);
      if (responseModel.result == 1) {
        DialogHelper.showInformDialog(context, tr("email_send"),
            button: tr("ok"), onPositive: openAuthPage);
      } else {
        DialogHelper.showInformDialog(context, tr("user_exist"),
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
    emailController.addListener(() {
      if (!EmailValidator.validate(emailController.text) &&
          emailController.text.isNotEmpty) {
        setState(() {
          emailErrorMessage = tr("invalid_format");
        });
        setEmailError(true);
      } else {
        setEmailError(false);
      }
    });
    passwordController.addListener(() {
      if (passwordController.text.isNotEmpty &&
          passwordController.text.length < minPasswordLength) {
        setState(() {
          passwordErrorMessage =
              tr("password_must_longer", args: [minPasswordLength.toString()]);
        });
        setPasswordError(true);
      } else {
        setPasswordError(false);
      }
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
        emailErrorMessage = tr("enter_email");
      });
      setEmailError(true);
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordErrorMessage = tr("enter_password");
      });
      setPasswordError(true);
      isValid = false;
    }
    if (confirmPasswordController.text.isEmpty) {
      setState(() {
        confirmPasswordErrorMessage = tr("enter_password_again");
      });
      setConfirmPasswordError(true);
      isValid = false;
    }
    if (passwordController.text.isNotEmpty &&
        passwordController.text.length < minPasswordLength) {
      setState(() {
        passwordErrorMessage =
            tr("password_must_longer", args: [minPasswordLength.toString()]);
      });
      setPasswordError(true);
      isValid = false;
    }
    if (emailController.text.isNotEmpty &&
        !EmailValidator.validate(emailController.text)) {
      setState(() {
        emailErrorMessage = tr("invalid_format");
      });
      setEmailError(true);
      isValid = false;
    }
    if (confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text != passwordController.text &&
        passwordController.text.isNotEmpty) {
      setState(() {
        confirmPasswordErrorMessage = tr("passwords_not_match");
      });
      setConfirmPasswordError(true);
      isValid = false;
    }

    if (isValid) {
      setLoading(true);
      RegistrationModel registrationModel = RegistrationModel(
          loginController.text, emailController.text, passwordController.text);
      var locale = context.locale;
      String lang = "en";
      if (locale.languageCode == "uk") {
        lang = "ua";
      } else {
        lang = "en";
      }
      registrationBloc.registrationFetcher(registrationModel, lang);
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
                    if (value.languageCode == "uk") {
                      name = "Укр";
                      image = "ukraine.png";
                    }

                    return DropdownMenuItem<Locale>(
                      value: value,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/$image",
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
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
                      tr("registration"),
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
                          textEditingController: emailController,
                          isError: emailError,
                          enable: !isLoading,
                          onSubmitted: (value) => checkFields(),
                          label: tr("email"),
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
                        label: tr("password"),
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
                        label: tr("password_confirmation"),
                        errorText: confirmPasswordErrorMessage,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    BaseButton(
                      isLoading: isLoading,
                      title: tr("register"),
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
