import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
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

  String emailErrorMessage = tr("enter_email");
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
        DialogHelper.showInformDialog(context, tr("new_password_sent"),
            button: tr("ok"), onPositive: openAuthPage);
      } else {
        DialogHelper.showInformDialog(context, tr("no_user_with_email"),
            button: tr("ok"), onPositive: () => Navigator.pop(context));
      }
    }, onError: (e) {
      setLoading(false);
      DialogHelper.showInformDialog(
          context, tr("error_occurred", args: [e.toString()]),
          button: tr("ok"), onPositive: () => Navigator.pop(context));
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
        emailErrorMessage = tr("enter_email");
      });
      setEmailError(true);
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
                      tr("recover_password"),
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
                          label: tr("email"),
                          errorText: emailErrorMessage),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    BaseButton(
                      isLoading: isLoading,
                      title: tr("recover_password"),
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
