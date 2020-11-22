/*
 * Copyright (c) 2020.  Dmytro Poroshyn
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servelyzer/style/my_colors.dart';

///[SqPicker] for get user birthday
class MyDatePicker {
  ///[context]
  BuildContext context;
  DateTime date = DateTime.now();

  ///On Date Time Changed
  final ValueChanged<DateTime> onDateTimeChanged;

  final TextStyle buttonTextStyle;
  final String buttonText;

  final FixedExtentScrollController controller;

  ///Constructor [SqPicker]
  ///[onPickerChanged] is required
  MyDatePicker(
    this.context, {
    this.date,
    this.controller,
    @required this.buttonText,
    this.buttonTextStyle = const TextStyle(fontSize: 15, color: MyColors.green),
    @required this.onDateTimeChanged,
  });

  //Show modal popup
  void show() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CupertinoButton(
                      child: Text(
                        buttonText,
                        style: buttonTextStyle,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onDateTimeChanged(date);
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  use24hFormat: true,
                  backgroundColor: MyColors.background,
                  onDateTimeChanged: (date) {
                    this.date = date;
                    onDateTimeChanged(date);
                  },
                  minimumDate: DateTime(DateTime.now().year - 130),
                  initialDateTime: date,
                  maximumDate: DateTime.now().add(Duration(seconds: 1)),
                )),
              ],
            ),
          );
        });
  }
}
