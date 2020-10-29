import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:servelyzer/style/my_colors.dart';

import 'base_button.dart';

class MyDialog extends StatelessWidget {
  final String content, positiveButton, negativeButton, button;
  final VoidCallback onPositive;
  final bool isInform;

  MyDialog({
    this.content,
    this.positiveButton = "Так",
    this.negativeButton = "Ні",
    this.onPositive,
    this.button,
  }) : isInform = false;

  MyDialog.information({
    this.content,
    this.button,
    this.onPositive,
    this.positiveButton,
    this.negativeButton,
  }) : isInform = true;

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
              child: isInform ? informContent(context) : dialogContent(context),
            ))));
  }

  informContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Center(
                child: AutoSizeText(content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500)))),
        BaseButton(
          onPressed: onPositive,
          title: button,
          height: 35,
        )
      ],
    );
  }

  dialogContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Center(
                child: AutoSizeText(content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500)))),
        Row(
          children: [
            Expanded(
                child: BaseButton(
              onPressed: () => Navigator.pop(context),
              title: negativeButton,
              height: 35,
              color: MyColors.grey,
            )),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: BaseButton(
              onPressed: onPositive,
              height: 35,
              title: positiveButton,
            )),
          ],
        )
      ],
    );
  }
}
