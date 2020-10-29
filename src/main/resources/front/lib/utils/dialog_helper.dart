import 'package:flutter/material.dart';
import 'package:servelyzer/widget/my_dialog.dart';

class DialogHelper {
  static showInformDialog(BuildContext context, String text,
      {String button = "Ок", @required VoidCallback onPositive}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => MyDialog.information(
        content: text,
        button: button,
        onPositive: onPositive,
      ),
    );
  }
}
