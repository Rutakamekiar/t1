import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailVerifiedPage extends StatefulWidget {
  @override
  _EmailVerifiedPageState createState() => _EmailVerifiedPageState();
}

class _EmailVerifiedPageState extends State<EmailVerifiedPage> {
  openAuthPage() {
    Modular.to.pushNamedAndRemoveUntil('/auth', (route) => false);
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
                      tr("email_confirmed"),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 24),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    BaseButton(
                      isLoading: false,
                      title: tr("log_in"),
                      onPressed: openAuthPage,
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
