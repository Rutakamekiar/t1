import 'package:flutter/material.dart';
import 'package:servelyzer/style/my_colors.dart';

class BaseTextField extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final bool obscureText;
  final bool isError;
  final String hintText;

  final bool enable;
  final String errorText;

  final Function(dynamic) onSubmitted;

  const BaseTextField({
    Key key,
    this.label,
    this.textEditingController,
    this.obscureText = false,
    this.isError = false,
    this.errorText = "",
    this.enable = true,
    this.onSubmitted, this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.black)),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: textEditingController,
          cursorColor: MyColors.green,
          enabled: enable,
          onSubmitted: onSubmitted,
          obscureText: obscureText,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            errorText: isError ? errorText : null,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: MyColors.grey, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: MyColors.green, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: MyColors.red, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: MyColors.green, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: MyColors.grey, width: 1.0),
            ),
          ),
        ),
      ],
    );
  }
}
