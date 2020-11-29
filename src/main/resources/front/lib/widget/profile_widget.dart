import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/style/my_colors.dart';

const double maxWight = 1110;
const double listWight = 600;

class ProfileWidget extends StatelessWidget {
  final VoidCallback onImagePressed;
  final VoidCallback onPremiumPressed;
  final Uint8List imageByte;
  final ResponseModel userResponse;
  final bool isLoadingAvatar;

  const ProfileWidget(
      {Key key,
      this.onImagePressed,
      this.imageByte,
      this.userResponse,
      this.isLoadingAvatar = false, this.onPremiumPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        height: 75,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MediaQuery.of(context).size.width <= listWight
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            isLoadingAvatar
                ? Container(
                    height: 45,
                    width: 45,
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(),
                  )
                : ButtonTheme(
                    minWidth: 45,
                    child: FlatButton(
                      onPressed: onImagePressed,
                      padding: EdgeInsets.zero,
                      shape: CircleBorder(),
                      child: imageByte != null
                          ? Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: MemoryImage(imageByte))))
                          : Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: MyColors.grey),
                              child: Image.asset(
                                "assets/camera.png",
                                width: 35,
                                height: 35,
                                color: Colors.white,
                              )),
                    ),
                  ),
            SizedBox(
              width: 16,
            ),
            Text(
              userResponse?.user ?? "username",
              style: TextStyle(fontSize: 20),
            ),
            Visibility(
              visible: userResponse?.userStatus != 'premium' && userResponse?.userStatus != 'admin' ?? true,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: onPremiumPressed,
                  child: Text(tr("become_premium"), style:TextStyle(color: MyColors.green)),
                ),
              ),
            )
          ],
        ));
  }
}
