import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servelyzer/style/my_colors.dart';

import 'base_button.dart';

class MyDateDialog extends StatefulWidget {
  final String content, positiveButton, negativeButton, button;
  final Function(DateTime) onPositive;
  final DateTime initTime;

  final DateTime minTime;
  final DateTime maxTime;

  MyDateDialog({
    this.content,
    this.positiveButton = "Обрати",
    this.negativeButton = "Скасувати",
    this.onPositive,
    this.button,
    this.initTime,
    this.minTime,
    this.maxTime,
  });

  @override
  _MyDateDialogState createState() => _MyDateDialogState();
}

class _MyDateDialogState extends State<MyDateDialog> {
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    date = widget.initTime ?? DateTime.now();
  }

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
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.dateAndTime,
          backgroundColor: Colors.white,
          onDateTimeChanged: (date) {
              this.date = date;
          },
          minimumDate: widget.minTime ?? DateTime(DateTime.now().year - 1),
          initialDateTime: date,
          maximumDate: widget.maxTime,
        ),
            )),
        Row(
          children: [
            Expanded(
                child: BaseButton(
              onPressed: () => Navigator.pop(context),
              title: widget.negativeButton,
              height: 35,
              color: MyColors.grey,
            )),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: BaseButton(
              onPressed: () => widget.onPositive(date),
              height: 35,
              title: widget.positiveButton,
            )),
          ],
        )
      ],
    );
  }
}
