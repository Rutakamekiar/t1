import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:servelyzer/bloc/reset_password_bloc.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/utils/dialog_helper.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:servelyzer/widget/base_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final ResetPasswordBloc resetPasswordBloc = ResetPasswordBloc();

  final TextEditingController emailController = TextEditingController();

  String emailErrorMessage = "Введіть e-mail";
  bool emailError = false;
  bool isLoading = false;

  openAuthPage() {
    Modular.to.pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  void initState() {
    super.initState();
    resetPasswordBloc.resetPassword.listen((responseModel) {
      setLoading(false);
      if (responseModel.result == 2) {
        DialogHelper.showInformDialog(
            context, "Новий пароль відправлено на email",
            onPositive: openAuthPage);
      } else {
        DialogHelper.showInformDialog(
            context, "Користувача з даним email не знайдено",
            onPositive: () => Navigator.pop(context));
      }
    }, onError: (e) {
      setLoading(false);
      DialogHelper.showInformDialog(context, "Виникла помылка: ${e.toString()}",
          onPositive: () => Navigator.pop(context));
    });
    emailController.addListener(() {
      if (!EmailValidator.validate(emailController.text) &&
          emailController.text.isNotEmpty) {
        setState(() {
          emailErrorMessage = "Невірний формат";
        });
        setEmailError(true);
      } else {
        setEmailError(false);
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    resetPasswordBloc.dispose();
    super.dispose();
  }

  setEmailError(bool state) {
    if (emailError != state) {
      setState(() {
        emailError = state;
      });
    }
  }

  checkFields() {
    bool isValid = true;
    if (emailController.text.isEmpty) {
      setState(() {
        emailErrorMessage = "Введіть e-mail";
      });
      setEmailError(true);
      isValid = false;
    }
    if (emailController.text.isNotEmpty &&
        !EmailValidator.validate(emailController.text)) {
      setState(() {
        emailErrorMessage = "Невірний формат";
      });
      setEmailError(true);
      isValid = false;
    }

    if (isValid) {
      setLoading(true);
      resetPasswordBloc.resetPasswordFetcher(emailController.text);
    }
  }

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
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
                      "Відновити пароль",
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
                          textEditingController: emailController,
                          isError: emailError,
                          enable: !isLoading,
                          onSubmitted: (value) => checkFields(),
                          label: "E-mail",
                          errorText: emailErrorMessage),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    BaseButton(
                      isLoading: isLoading,
                      title: "Відновити пароль",
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
