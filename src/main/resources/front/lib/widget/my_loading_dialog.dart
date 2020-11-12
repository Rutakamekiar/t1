import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MyLoadingDialog extends StatelessWidget {
  final String content;

  MyLoadingDialog({
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: SizedBox(
            height: 300,
            width: 505,
            child: Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
              child: dialogContent(context),
            ))));
  }

  dialogContent(BuildContext context) {
    return Column(
      children: <Widget>[
        AutoSizeText(content,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
        Expanded(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }
}
