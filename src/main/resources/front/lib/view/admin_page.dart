import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:servelyzer/bloc/admin_bloc.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/model/users_model.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/utils/dialog_helper.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:servelyzer/widget/my_dialog.dart';
import 'package:servelyzer/widget/my_status_picker.dart';
import 'package:servelyzer/widget/profile_widget.dart';

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

    _adminBloc.clearHosts.listen((event) {
      _adminBloc.usersFetcher();
    });

    _adminBloc.clearAvatar.listen((event) {
      _adminBloc.usersFetcher();
    });

    _adminBloc.setFreeUser.listen((event) {
      _adminBloc.usersFetcher();
    });

    _adminBloc.setPremiumUser.listen((event) {
      _adminBloc.usersFetcher();
    });

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
          DialogHelper.showInformDialog(context, tr("you_not_admin"),
              button: tr("ok"),
              onPositive: () => Modular.to.pushReplacementNamed('/auth'));
        }
      } else {
        DialogHelper.showInformDialog(
            context, tr("error_occurred", args: [event.message]),
            button: tr("ok"),
            onPositive: () => Modular.to.pushReplacementNamed('/auth'));
      }
    }, onError: (e) {
      DialogHelper.showInformDialog(
          context, tr("error_occurred", args: [e.toString()]),
          button: tr("ok"),
          onPositive: () => Modular.to.pushReplacementNamed('/auth'));
    });
  }

  _startFilePicker() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((e) async {
      DialogHelper.showLoadingDialog(context, tr("image_upload"));
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        FileReader reader = FileReader();
        reader.onLoadEnd.listen((e) async {
          MemoryImage memoryImage = MemoryImage(reader.result);
          memoryImage
              .resolve(new ImageConfiguration())
              .addListener(ImageStreamListener((ImageInfo info, bool _) {
                int wight = info.image.width;
                int height = info.image.height;
                if (height > 1000 || wight > 1000) {
                  Navigator.pop(context);
                  DialogHelper.showInformDialog(context, tr("image_error"),
                      button: tr("ok"),
                      onPositive: () => Navigator.pop(context));
                } else {
                  _myWorker.postMessage(reader.result);
                }
              }, onError: (object, e) {
                Navigator.pop(context);
                DialogHelper.showInformDialog(context, tr("image_format_error"),
                    button: tr("ok"), onPositive: () => Navigator.pop(context));
              }));
        });
        reader.onError.listen((fileEvent) {
          Navigator.pop(context);
          print("error");
        });
        reader.readAsArrayBuffer(file);
      }
    });
  }

  _changeUserStatus(String login, UserStatus status) {
    String dropdownValue = "Free";
    switch (status) {
      case UserStatus.FREE:
        dropdownValue = "Free";
        break;
      case UserStatus.PREMIUM:
        dropdownValue = "Premium";
        break;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => MyStatusPicker(
        content: tr("select_status"),
        negativeButton: tr("cancel"),
        positiveButton: tr("choose"),
        onPositive: (newStatus) {
          switch (newStatus) {
            case "Free":
              _adminBloc.setFreeUserFetcher(login);
              break;
            case "Premium":
              _adminBloc.setPremiumUserFetcher(login);
              break;
          }
          Navigator.pop(context);
        },
        dropdownValue: dropdownValue,
      ),
    );
  }

  _clearAvatar(String login) {
    _adminBloc.clearAvatarFetcher(login);
  }

  _clearHosts(String login) {
    _adminBloc.clearHostsFetcher(login);
  }

  _openAuthorizationPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        content: tr("you_sure_want_logout"),
        negativeButton: tr("no"),
        positiveButton: tr("yes"),
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
                    constraints: BoxConstraints(maxWidth: maxWight),
                    child: Row(
                      mainAxisAlignment:
                          MediaQuery.of(context).size.width <= listWight
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.end,
                      children: [
                        DropdownButton<Locale>(
                          value: context.locale,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          iconEnabledColor: MyColors.green,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          underline: Container(
                            height: 0,
                            padding: EdgeInsets.only(top: 5),
                            color: MyColors.green,
                          ),
                          onChanged: (Locale newValue) {
                            print(newValue);
                            context.locale = newValue;
                          },
                          items: <Locale>[Locale("en"), Locale("uk")]
                              .map<DropdownMenuItem<Locale>>((Locale value) {
                            String name = "En";
                            String image = "united-kingdom.png";
                            if (value.languageCode == "uk") {
                              name = "Укр";
                              image = "ukraine.png";
                            }

                            return DropdownMenuItem<Locale>(
                              value: value,
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/$image",
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(name),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        BaseButton(
                          onPressed: _openAuthorizationPage,
                          height: 45,
                          width: 175,
                          title: tr("logout"),
                        ),
                      ],
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
                  padding:
                      EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 30),
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
                              //     children: [
                              //       UserItem(
                              //         onChangeStatus: _changeUserStatus,
                              //         onClearAvatar: _clearAvatar,
                              //         onClearHosts: _clearHosts,
                              //       ),
                              //       UserItem(),
                              //       UserItem()
                              //     ]);
                              if (snapshot.hasData) {
                                UsersModel usersModel = snapshot.data;
                                usersModel.users.sort((User a, User b) =>
                                    a.login.compareTo(b.login));
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
                                        onChangeStatus: _changeUserStatus,
                                        onClearAvatar: _clearAvatar,
                                        onClearHosts: _clearHosts,
                                      );
                                    });
                              } else if (snapshot.hasError) {
                                final exception = snapshot.error;
                                return _buildError(tr("error_occurred",
                                    args: [exception.toString()]));
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
  final Function(String, UserStatus) onChangeStatus;
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
        status = tr("yes");
        break;
      case VerificationStatus.NOT_VERIFICATED:
        status = tr("no");
        break;
    }
    return tr("confirmed", args: [status]);
  }

  _getAvatarStatus() {
    String status = "";
    switch (user?.avatar) {
      case Avatar.EMPTY:
        status = tr("no");
        break;
      case Avatar.NOT_EMPTY:
        status = tr("yes");
        break;
    }
    return tr("avatar", args: [status]);
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
    return tr("status", args: [status]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: MediaQuery.of(context).size.width <= 950
          ? ExpansionTile(
              childrenPadding: EdgeInsets.symmetric(vertical: 10),
              children: [
                Text(_getVerificationStatus()),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  onPressed: () => onClearAvatar(user?.login),
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
                  height: 10,
                ),
                FlatButton(
                  onPressed: () =>
                      onChangeStatus(user?.login, user?.userStatus),
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
                  height: 10,
                ),
                FlatButton(
                  onPressed: () => onClearHosts(user?.login),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: Text(
                      tr("clear_host_list"),
                      style: TextStyle(
                          color: MyColors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: MyColors.green)),
                )
              ],
              title: Center(child: Text(user?.login ?? "Username")),
            )
          : buildRow(),
    );
  }

  Row buildRow() {
    return Row(
      children: [
        Expanded(child: Text(user?.login ?? "Username")),
        SizedBox(
          width: 30,
        ),
        Text(_getVerificationStatus()),
        SizedBox(
          width: 30,
        ),
        FlatButton(
          onPressed: () => onClearAvatar(user?.login),
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              _getAvatarStatus(),
              style:
                  TextStyle(color: MyColors.green, fontWeight: FontWeight.bold),
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
          onPressed: () => onChangeStatus(user?.login, user?.userStatus),
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              _getStatus(),
              style:
                  TextStyle(color: MyColors.green, fontWeight: FontWeight.bold),
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
          onPressed: () => onClearHosts(user?.login),
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              tr("clear_host_list"),
              style:
                  TextStyle(color: MyColors.green, fontWeight: FontWeight.bold),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: MyColors.green)),
        )
      ],
    );
  }
}
