// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:servelyzer/bloc/admin_bloc.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/model/users_model.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/utils/dialog_helper.dart';
import 'package:servelyzer/view/profile_widget.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:servelyzer/widget/my_dialog.dart';

const double maxWight = 1110;
const double listWight = 600;

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _adminBloc = AdminBloc();

  bool _isLoadingLogin = true;
  bool _isLoadingAvatar = true;
  Uint8List _uploadedImage;
  ResponseModel _userResponse;
  Worker _myWorker = new Worker('worker.js');

  @override
  void initState() {
    super.initState();

    // _isLoadingLogin = false;
    // _adminBloc.usersFetcher();

    _adminBloc.loginFetcher();

    _myWorker.onMessage.listen((e) {
      String imageData = base64Encode(e.data);
      _adminBloc.setAvatar(imageData);
    });
    _adminBloc.avatar.listen((event) {
      setState(() {
        _isLoadingAvatar = false;
      });
      if (event.result == 1) {
        var imageData = base64Decode(event.message);
        setState(() {
          _uploadedImage = imageData;
        });
      }
    }, onError: (e) {
      setState(() {
        _isLoadingAvatar = false;
      });
    });

    _adminBloc.login.listen((event) {
      if (event.result == 1) {
        if (event.userStatus == "admin") {
          setState(() {
            _isLoadingLogin = false;
          });
          _adminBloc.usersFetcher();
          _adminBloc.getAvatar();
          _userResponse = event;
        } else {
          DialogHelper.showInformDialog(context, "Ви не є адміністратором",
              onPositive: () => Modular.to.pushReplacementNamed('/auth'));
        }
      } else {
        DialogHelper.showInformDialog(
            context, "Виникла помилка: ${event.message}",
            onPositive: () => Modular.to.pushReplacementNamed('/auth'));
      }
    }, onError: (e) {
      DialogHelper.showInformDialog(context, "Виникла помилка: ${e.toString()}",
          onPositive: () => Modular.to.pushReplacementNamed('/auth'));
    });
  }

  _startFilePicker() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((e) async {
      DialogHelper.showLoadingDialog(context, "Завантаження зображення");
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        FileReader reader = FileReader();
        reader.onLoadEnd.listen((e) async {
          _myWorker.postMessage(reader.result);
        });
        reader.onError.listen((fileEvent) {
          Navigator.pop(context);
          print("error");
        });
        reader.readAsArrayBuffer(file);
      }
    });
  }

  _openAuthorizationPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        content: "Ви впевнені, що хочите вийти",
        negativeButton: "Ні",
        positiveButton: "Так",
        onPositive: () {
          _adminBloc.logoutFetcher();
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
        ),
        Icon(
          Icons.warning_amber_rounded,
          size: 50,
          color: MyColors.grey,
        ),
        SizedBox(
          height: 20,
        ),
        AutoSizeText(message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _adminBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.background,
        body: _isLoadingLogin
            ? Center(child: CircularProgressIndicator())
            : Column(children: [
                Container(
                  height: 75,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    alignment: MediaQuery.of(context).size.width <= listWight
                        ? null
                        : Alignment.centerRight,
                    constraints: BoxConstraints(maxWidth: maxWight),
                    child: BaseButton(
                      onPressed: _openAuthorizationPage,
                      height: 45,
                      width: 175,
                      title: "Вийти",
                    ),
                  ),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(232, 228, 228, 0.5),
                        offset: Offset(0, 14),
                        blurRadius: 23)
                  ]),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 30, left: 15, right: 15),
                  constraints: BoxConstraints(maxWidth: maxWight),
                  child: ProfileWidget(
                    imageByte: _uploadedImage,
                    isLoadingAvatar: _isLoadingAvatar,
                    onImagePressed: _startFilePicker,
                    userResponse: _userResponse,
                  ),
                ),
                Expanded(
                    child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: maxWight),
                        child: StreamBuilder<Object>(
                            stream: _adminBloc.users,
                            builder: (context, snapshot) {
                              // return ListView(
                              //     padding: EdgeInsets.only(
                              //         left: 15, right: 15, top: 30, bottom: 15),
                              //     children: [UserItem(), UserItem(), UserItem()]);

                              if (snapshot.hasData) {
                                UsersModel usersModel = snapshot.data;
                                return ListView.builder(
                                    itemCount: usersModel.users.length,
                                    padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 30,
                                        bottom: 15),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      User user = usersModel.users[index];
                                      return UserItem(
                                        user: user,
                                      );
                                    });
                              } else if (snapshot.hasError) {
                                final exception = snapshot.error;
                                return _buildError("Помилка: $exception");
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }))),
              ]));
  }
}

class UserItem extends StatelessWidget {
  final User user;
  final Function(String) onClearHosts;
  final Function(String) onChangeStatus;
  final Function(String) onClearAvatar;

  const UserItem(
      {Key key,
      this.user,
      this.onClearHosts,
      this.onChangeStatus,
      this.onClearAvatar})
      : super(key: key);

  _getVerificationStatus() {
    String status = "";
    switch (user?.verificationStatus) {
      case VerificationStatus.VERIFICATED:
        status = "так";
        break;
      case VerificationStatus.NOT_VERIFICATED:
        status = "ні";
        break;
    }
    return "Підтвердженний: $status";
  }

  _getAvatarStatus() {
    String status = "";
    switch (user?.avatar) {
      case Avatar.EMPTY:
        status = "ні";
        break;
      case Avatar.NOT_EMPTY:
        status = "так";
        break;
    }
    return "Аватар: $status";
  }

  _getStatus() {
    String status = "";
    switch (user?.userStatus) {
      case UserStatus.FREE:
        status = "Free";
        break;
      case UserStatus.PREMIUM:
        status = "Premium";
        break;
    }
    return "Статус: $status";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Expanded(child: Text("Username")),
          SizedBox(
            width: 30,
          ),
          Text(_getVerificationStatus()),
          SizedBox(
            width: 30,
          ),
          FlatButton(
            onPressed: onClearAvatar(user.login),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              child: Text(
                _getAvatarStatus(),
                style: TextStyle(
                    color: MyColors.green, fontWeight: FontWeight.bold),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: MyColors.green)),
          ),
          SizedBox(
            width: 30,
          ),
          FlatButton(
            onPressed: onChangeStatus(user.login),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              child: Text(
                _getStatus(),
                style: TextStyle(
                    color: MyColors.green, fontWeight: FontWeight.bold),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: MyColors.green)),
          ),
          SizedBox(
            width: 30,
          ),
          FlatButton(
            onPressed: onClearHosts(user.login),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              child: Text(
                "Очистити список хостів",
                style: TextStyle(
                    color: MyColors.green, fontWeight: FontWeight.bold),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: MyColors.green)),
          )
        ],
      ),
    );
  }
}
