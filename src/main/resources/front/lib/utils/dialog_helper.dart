import 'package:flutter/material.dart';
import 'package:servelyzer/widget/my_dialog.dart';
import 'package:servelyzer/widget/my_loading_dialog.dart';

class DialogHelper {
  static showInformDialog(BuildContext context, String text,
      {@required String button, @required VoidCallback onPositive}) {
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

  static showLoadingDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => MyLoadingDialog(
        content: text,
      ),
    );
  }
}
