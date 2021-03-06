import 'package:flutter/material.dart';
import 'package:servelyzer/style/my_colors.dart';

class BaseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double height;
  final double width;

  final Color color;

  final bool isLoading;

  const BaseButton({
    Key key,
    this.onPressed,
    @required this.title,
    this.height = 50,
    this.width = double.infinity,
    this.isLoading = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: isLoading ? null : onPressed,
        color: color ?? MyColors.green,
        disabledColor: color ?? MyColors.green,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isLoading ? height : 10)),
        padding: EdgeInsets.all(16),
        child: AnimatedContainer(
          height: height,
          width: isLoading ? height : width,
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: 277),
          duration: Duration(milliseconds: 500),
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  title,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
        ));
  }
}
