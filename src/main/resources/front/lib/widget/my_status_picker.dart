import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:servelyzer/style/my_colors.dart';

import 'base_button.dart';

class MyStatusPicker extends StatefulWidget {
  final String content, positiveButton, negativeButton;
  final Function(String) onPositive;
  final String dropdownValue;

  MyStatusPicker({
    this.content,
    @required this.positiveButton,
    @required this.negativeButton,
    this.onPositive,
    @required this.dropdownValue,
  });

  @override
  _MyStatusPickerState createState() => _MyStatusPickerState();
}

class _MyStatusPickerState extends State<MyStatusPicker> {
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.dropdownValue;
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
        AutoSizeText(widget.content,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
        Expanded(child: SizedBox()),
        DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          iconEnabledColor: MyColors.green,
          style: TextStyle(color: Colors.black, fontSize: 30),
          underline: Container(
            height: 2,
            padding: EdgeInsets.only(top: 5),
            color: MyColors.green,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['Free', 'Premium']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Expanded(child: SizedBox()),
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
              onPressed: () => widget.onPositive(dropdownValue),
              height: 35,
              title: widget.positiveButton,
            )),
          ],
        )
      ],
    );
  }
}
