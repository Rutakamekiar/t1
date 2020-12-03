import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:servelyzer/bloc/main_bloc.dart';
import 'package:servelyzer/model/UptimeModel.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/model/hosts_model.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/utils/dialog_helper.dart';
import 'package:servelyzer/widget/MyPremiumDialog.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:servelyzer/widget/base_text_field.dart';
import 'package:servelyzer/widget/my_date_dialog.dart';
import 'package:servelyzer/widget/my_dialog.dart';
import 'package:servelyzer/widget/profile_widget.dart';

const double maxWight = 1110;
const double listWight = 600;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _mainBloc = MainBloc();

  TextEditingController _publicKeyController = TextEditingController();
  TextEditingController _privateKeyController = TextEditingController();
  TextEditingController _uptimeController = TextEditingController();

  int _currentId = 0;
  bool _isLoadingData = false;
  bool _isLoadingUptime = false;
  bool _isLoadingServers = false;
  bool _isLoadingLogin = true;
  HostsModel _hostsModel;

  DateTime _minTime = DateTime.now().subtract(Duration(hours: 2)).toUtc();
  DateTime _maxTime = DateTime.now().toUtc();

  String _minTimeText = "";
  String _maxTimeText = "";
  Uint8List _uploadedImage;

  bool _isEmptyData = false;
  bool _isLoadingAvatar = true;
  ResponseModel _userResponse;
  Worker _myWorker = new Worker('worker.js');

  @override
  void initState() {
    super.initState();
    _myWorker.onMessage.listen((e) {
      String imageData = base64Encode(e.data);
      _mainBloc.setAvatar(imageData);
    });

    _mainBloc.avatar.listen((event) {
      setState(() {
        _isLoadingAvatar = false;
      });
      if (event.result == 1 &&
          event.message != null &&
          event.message != "null") {
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

    _mainBloc.newAvatar.listen((event) {
      if (event.result == 1) {
        Navigator.pop(context);
        setState(() {
          _isLoadingAvatar = true;
        });
        _mainBloc.getAvatar();
      } else {
        Navigator.pop(context);
        DialogHelper.showInformDialog(context, tr("error_loading"),
            button: tr("ok"), onPositive: () => Navigator.pop(context));
      }
    }, onError: (e) {
      Navigator.pop(context);
      DialogHelper.showInformDialog(context, tr("error_loading"),
          button: tr("ok"), onPositive: () => Navigator.pop(context));
    });

    _minTimeText = DateFormat('dd.MM kk:mm').format(_minTime.toLocal());
    _maxTimeText = DateFormat('dd.MM kk:mm').format(_maxTime.toLocal());

    // _isLoadingLogin = false;
    // _isLoadingServers = false;
    // _isLoadingAvatar = false;
    // mainBloc.getServers();
    _mainBloc.loginFetcher();

    // mainBloc.dataFetcher(
    //     "t1-tss2020",
    //     DateTime.now().subtract(Duration(days: 10)).toUtc().toString(),
    //     DateTime.now().toUtc().toString());

    _mainBloc.data.listen((data) {
      _setLoading(false);
    }, onError: (e) {
      _setLoading(false);
    });
    _mainBloc.login.listen((event) {
      if (event.result == 1) {
        setState(() {
          _isLoadingLogin = false;
        });
        _mainBloc.getAvatar();
        _userResponse = event;
        _mainBloc.getServers();
        _mainBloc.getUptime();
      } else {
        Modular.to.pushReplacementNamed('/auth');
      }
    }, onError: (e) {
      Modular.to.pushReplacementNamed('/auth');
    });

    _mainBloc.logout.listen((event) {
      Modular.to.pushReplacementNamed('/auth');
    }, onError: (e) {
      DialogHelper.showInformDialog(
          context, tr("error_occurred", args: [e.toString()]),
          button: tr("ok"),
          onPositive: () => Modular.to.pushReplacementNamed('/auth'));
    });

    _mainBloc.uptime.listen((model) {
      _setLoadingUptime(false);
    }, onError: (e) {
      _setLoadingUptime(false);
      DialogHelper.showInformDialog(
          context, tr("error_occurred", args: [e.toString()]),
          button: tr("ok"), onPositive: () => Navigator.pop(context));
    });
    _mainBloc.servers.listen((model) {
      _setLoadingServers(false);
      _hostsModel = model;

      if (_hostsModel.hosts != null && _hostsModel.hosts.isNotEmpty) {
        if (_currentId == _hostsModel.hosts.length) {
          _currentId = _currentId - 1;
        }
        setState(() {
          _isEmptyData = false;
        });
        _setLoading(true);
        _mainBloc.dataFetcher(_hostsModel.hosts[_currentId].host,
            _minTime.toUtc().toString(), _maxTime.toUtc().toString());
      } else {
        setState(() {
          _isEmptyData = true;
        });
      }
    }, onError: (e) {
      _setLoadingServers(false);
      DialogHelper.showInformDialog(
          context, tr("error_occurred", args: [e.toString()]),
          button: tr("ok"), onPositive: () => Navigator.pop(context));
    });
    _mainBloc.addUrlStream.listen((event) {
      if (event.message == "Update to premium to add more urls to check") {
        DialogHelper.showInformDialog(context, tr("url_limit_error"),
            button: tr("ok"), onPositive: () => Navigator.pop(context));
      }
      _mainBloc.getUptime();
    }, onError: (e) {
      _setLoadingUptime(false);
      DialogHelper.showInformDialog(
          context, tr("error_occurred", args: [e.toString()]),
          button: tr("ok"), onPositive: () => Navigator.pop(context));
    });
    _mainBloc.deleteUrlStream.listen((event) {
      _mainBloc.getUptime();
    }, onError: (e) {
      _setLoadingUptime(false);
      DialogHelper.showInformDialog(
          context, tr("error_occurred", args: [e.toString()]),
          button: tr("ok"), onPositive: () => Navigator.pop(context));
    });
    _mainBloc.add.listen((event) {
      if (event.message == "Update to premium to add more servers") {
        DialogHelper.showInformDialog(context, tr("servers_limit_error"),
            button: tr("ok"), onPositive: () => Navigator.pop(context));
      }
      _mainBloc.getServers();
    }, onError: (e) {
      _setLoadingServers(false);
      DialogHelper.showInformDialog(
          context, tr("error_occurred", args: [e.toString()]),
          button: tr("ok"), onPositive: () => Navigator.pop(context));
    });
    _mainBloc.delete.listen((event) {
      _mainBloc.getServers();
    }, onError: (e) {
      _setLoadingServers(false);
      DialogHelper.showInformDialog(
          context, tr("error_occurred", args: [e.toString()]),
          button: tr("ok"), onPositive: () => Navigator.pop(context));
    });
  }

  _setLoadingUptime(bool value) {
    if (_isLoadingUptime != value)
      setState(() {
        _isLoadingUptime = value;
      });
  }

  _setLoadingServers(bool value) {
    if (_isLoadingServers != value)
      setState(() {
        _isLoadingServers = value;
      });
  }

  _openMinTimeDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => MyDateDialog(
              onPositive: (date) {
                Navigator.pop(context);
                setState(() {
                  _minTime = date;
                  _minTimeText =
                      DateFormat('dd.MM kk:mm').format(_minTime.toLocal());
                  if (_hostsModel?.hosts != null &&
                      _hostsModel.hosts.isNotEmpty) {
                    _setLoading(true);
                    _mainBloc.dataFetcher(
                        _hostsModel.hosts[_currentId].host,
                        _minTime.toUtc().toString(),
                        _maxTime.toUtc().toString());
                  }
                });
              },
              initTime: _minTime,
              maxTime: _maxTime,
              negativeButton: tr("cancel"),
              positiveButton: tr("choose"),
            ));
  }

  _openMaxTimeDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => MyDateDialog(
              negativeButton: tr("cancel"),
              positiveButton: tr("choose"),
              onPositive: (date) {
                Navigator.pop(context);
                setState(() {
                  _maxTime = date;
                  _maxTimeText =
                      DateFormat('dd.MM kk:mm').format(_maxTime.toLocal());
                  if (_hostsModel?.hosts != null &&
                      _hostsModel.hosts.isNotEmpty) {
                    _setLoading(true);
                    _mainBloc.dataFetcher(
                        _hostsModel.hosts[_currentId].host,
                        _minTime.toUtc().toString(),
                        _maxTime.toUtc().toString());
                  }
                });
              },
              initTime: _maxTime,
              minTime: _minTime,
              maxTime: DateTime.now(),
            ));
  }

  _setLoading(bool value) {
    if (_isLoadingData != value)
      setState(() {
        _isLoadingData = value;
      });
  }

  _openAuthorizationPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        content: tr("you_sure_want_logout"),
        negativeButton: tr("no"),
        positiveButton: tr("yes"),
        onPositive: () {
          _mainBloc.logoutFetcher();
        },
      ),
    );
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
        });
        reader.readAsArrayBuffer(file);
      }
    });
  }

  _onPremiumPressed() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => MyPremiumDialog(
              onSuccess: () {
                setState(() {
                  _isLoadingLogin = true;
                });
                _mainBloc.loginFetcher();
              },
            ));
  }

  @override
  void dispose() {
    _mainBloc.dispose();
    _publicKeyController.dispose();
    _uptimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: _isLoadingLogin
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 30, bottom: 30),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: maxWight),
                        child: Column(
                          children: [
                            ProfileWidget(
                              imageByte: _uploadedImage,
                              onPremiumPressed: _onPremiumPressed,
                              isLoadingAvatar: _isLoadingAvatar,
                              onImagePressed: _startFilePicker,
                              userResponse: _userResponse,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              height:
                                  MediaQuery.of(context).size.width <= listWight
                                      ? 440
                                      : 240,
                              child: StreamBuilder<HostsModel>(
                                  stream: _mainBloc.servers,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      HostsModel hostsModel = snapshot.data;
                                      return _isLoadingServers
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : buildHostList(hostsModel);
                                    } else if (snapshot.hasError) {
                                      final exception = snapshot.error;
                                      return buildError(tr("error_occurred",
                                          args: [exception.toString()]));
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 240,
                              child: StreamBuilder<UptimeModel>(
                                  stream: _mainBloc.uptime,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      UptimeModel uptimeModel = snapshot.data;
                                      return _isLoadingUptime
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : buildUptimeList(uptimeModel);
                                    } else if (snapshot.hasError) {
                                      final exception = snapshot.error;
                                      return buildError(tr("error_occurred",
                                          args: [exception.toString()]));
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 15, bottom: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                width: MediaQuery.of(context).size.width <=
                                        listWight
                                    ? double.infinity
                                    : null,
                                height: MediaQuery.of(context).size.width <=
                                        listWight
                                    ? null
                                    : 105,
                                child: MediaQuery.of(context).size.width <=
                                        listWight
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(tr("interval")),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          FlatButton(
                                              onPressed: _openMinTimeDialog,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              padding: EdgeInsets.zero,
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: MyColors.grey)),
                                                child: Text(_minTimeText),
                                              )),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Text(tr("to")),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          FlatButton(
                                              onPressed: _openMaxTimeDialog,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              padding: EdgeInsets.zero,
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: MyColors.grey)),
                                                child: Text(_maxTimeText),
                                              )),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(tr("interval")),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          FlatButton(
                                              onPressed: _openMinTimeDialog,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              padding: EdgeInsets.zero,
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: MyColors.grey)),
                                                child: Text(_minTimeText),
                                              )),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(tr("to")),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          FlatButton(
                                              onPressed: _openMaxTimeDialog,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              padding: EdgeInsets.zero,
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: MyColors.grey)),
                                                child: Text(_maxTimeText),
                                              )),
                                        ],
                                      )),
                            StreamBuilder<DataListModel>(
                                stream: _mainBloc.data,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    DataListModel dataModel = snapshot.data;
                                    if (_isLoadingData) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    }
                                    if (_isEmptyData) {
                                      return Container();
                                    }
                                    return MediaQuery.of(context).size.width <=
                                            listWight
                                        ? buildList(dataModel.data)
                                        : buildRow(dataModel.data);
                                  } else if (snapshot.hasError) {
                                    String range =
                                        _minTime.toLocal().toString() +
                                            " - " +
                                            _maxTime.toLocal().toString();
                                    return buildError(tr("data_range_not_found",
                                        args: [range]));
                                  } else {
                                    return _isLoadingData
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 30),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          )
                                        : Container();
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Container buildUptimeList(UptimeModel uptimeModel) {
    List<Widget> list = List<Widget>();
    if (uptimeModel.uptime != null && uptimeModel.uptime.isNotEmpty) {
      for (int i = 0; i < uptimeModel.uptime.length; i++) {
        Uptime uptime = uptimeModel.uptime[i];
        list.add(UptimeItem(
          uptime: uptime,
          onDelete: (url) {
            showDialog(
              context: context,
              builder: (BuildContext context) => MyDialog(
                content: tr("you_sure_want_delete",
                    args: [uptimeModel.uptime[i].url]),
                negativeButton: tr("no"),
                positiveButton: tr("yes"),
                onPositive: () {
                  Navigator.pop(context);
                  _setLoadingUptime(true);
                  _mainBloc.deleteUrl(url);
                },
              ),
            );
          },
        ));
      }
    }

    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: uptimeModel.uptime == null || uptimeModel.uptime.isEmpty
                    ? Center(child: Text(tr("url_list_empty")))
                    : ListView(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        children: list,
                      )),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: BaseTextField(
                    textEditingController: _uptimeController,
                    onSubmitted: (value) => _addUptime(),
                    label: "",
                    hintText: "Url",
                    errorText: tr("enter_site_url")),
              ),
              SizedBox(
                width: 30,
              ),
              BaseButton(
                isLoading: false,
                width: 150,
                height: 37,
                title: tr("add"),
                onPressed: _addUptime,
              )
            ],
          )
        ],
      ),
    );
  }

  void _addUptime() {
    if (_uptimeController.text.isNotEmpty) {
      _setLoadingUptime(true);
      _mainBloc.addUrl(_uptimeController.text);
    }
  }

  void _addHost() {
    if (_publicKeyController.text.isNotEmpty &&
        _privateKeyController.text.isNotEmpty) {
      _setLoadingServers(true);
      _mainBloc.addServer(
          _publicKeyController.text, _privateKeyController.text);
    }
  }

  Container buildHostList(HostsModel hostsModel) {
    List<Widget> list = List<Widget>();
    if (hostsModel.hosts != null && hostsModel.hosts.isNotEmpty) {
      if (_currentId == hostsModel.hosts.length) {
        _currentId = _currentId - 1;
      }
      for (int i = 0; i < hostsModel.hosts.length; i++) {
        Host host = hostsModel.hosts[i];
        list.add(HostItem(
          title: host.host,
          id: i,
          currentId: _currentId,
          onDelete: (id) {
            showDialog(
              context: context,
              builder: (BuildContext context) => MyDialog(
                content: tr("you_sure_want_delete",
                    args: [hostsModel.hosts[id].host]),
                negativeButton: tr("no"),
                positiveButton: tr("yes"),
                onPositive: () {
                  Navigator.pop(context);
                  _setLoadingServers(true);
                  _mainBloc.deleteServer(hostsModel.hosts[id].host);
                },
              ),
            );
          },
          onSelected: (id) {
            setState(() {
              _currentId = id;
              _setLoading(true);
              _mainBloc.dataFetcher(hostsModel.hosts[_currentId].host,
                  _minTime.toUtc().toString(), _maxTime.toUtc().toString());
            });
          },
        ));
      }
    }

    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: hostsModel.hosts == null || hostsModel.hosts.isEmpty
                    ? Center(child: Text(tr("host_list_empty")))
                    : ListView(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        children: list,
                      )),
          ),
          MediaQuery.of(context).size.width <= listWight
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BaseTextField(
                        textEditingController: _publicKeyController,
                        onSubmitted: (value) => _addHost(),
                        label: "",
                        hintText: "Public key",
                        errorText: tr("enter_public_key")),
                    BaseTextField(
                        textEditingController: _privateKeyController,
                        onSubmitted: (value) => _addHost(),
                        label: "",
                        hintText: "Private key",
                        errorText: tr("enter_public_key")),
                    SizedBox(
                      height: 30,
                    ),
                    BaseButton(
                      isLoading: false,
                      height: 37,
                      title: tr("add"),
                      onPressed: _addHost,
                    )
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: BaseTextField(
                          textEditingController: _publicKeyController,
                          onSubmitted: (value) => _addHost(),
                          label: "",
                          hintText: "Public key",
                          errorText: tr("enter_public_key")),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: BaseTextField(
                          textEditingController: _privateKeyController,
                          onSubmitted: (value) => _addHost(),
                          label: "",
                          hintText: "Private key",
                          errorText: tr("enter_public_key")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    BaseButton(
                      isLoading: false,
                      width: 150,
                      height: 37,
                      title: tr("add"),
                      onPressed: _addHost,
                    )
                  ],
                )
        ],
      ),
    );
  }

  Column buildError(String message) {
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

  Widget buildList(List<DataModel> dataModels) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        MainPageItem(
          title: tr("using_CPU"),
          child: LineChart(
            chartData(linesCpuData(dataModels), isCPU: true),
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        ),
        MainPageItem(
          title: tr("memory_usage"),
          child: LineChart(
            chartData(linesMemoryData(dataModels)),
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        ),
      ],
    );
  }

  LineChartData chartData(List<LineChartBarData> data, {bool isCPU = false}) {
    double firstTime = data.first.spots.first.x;
    double lastTime = data.first.spots.last.x;

    double interval = 7200000;
    if (firstTime < lastTime) {
      interval = (lastTime - firstTime) / 2;
    } else if (firstTime > lastTime) {
      interval = (firstTime - lastTime) / 2;
    }

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItems: (touchedSpots) {
              List<LineTooltipItem> list = List<LineTooltipItem>();
              touchedSpots.forEach((element) {
                String time = DateFormat('dd.MM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(element.x.floor()));
                list.add(LineTooltipItem(
                    time + " - " + element.y.toString(),
                    TextStyle(
                        color: MyColors.green, fontWeight: FontWeight.bold)));
              });
              return list;
            }),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      minX: data.first.spots.first.x,
      maxX: data.first.spots.last.x,
      minY: isCPU ? 0 : 100,
      maxY: isCPU ? 100 : 500,
      axisTitleData: FlAxisTitleData(
          leftTitle: AxisTitle(
              showTitle: true,
              titleText: isCPU ? "CPU, %" : tr("memory_mb"),
              margin: 10,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400)),
          bottomTitle: AxisTitle(
              margin: 10,
              showTitle: true,
              titleText: tr("time"),
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400))),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 16,
          interval: interval,
          reservedSize: 5,
          getTitles: (value) {
            String time = DateFormat('dd.MM kk:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(value.floor()));
            return time;
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontSize: 11,
          ),
          margin: 16,
          interval: isCPU ? 10 : 50,
          reservedSize: 10,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: MyColors.grey,
            width: 1,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      lineBarsData: data,
    );
  }

  List<LineChartBarData> linesCpuData(List<DataModel> dataModels) {
    List<FlSpot> spots = List<FlSpot>();
    dataModels.forEach((dataModel) {
      Cpu cpu = dataModel.cpu.first;
      DateTime date = DateTime.parse(dataModel.at);
      double cpuTotal = cpu.system + cpu.user;
      spots.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), cpuTotal));
    });

    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [MyColors.green],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
    ];
  }

  List<LineChartBarData> linesMemoryData(List<DataModel> dataModels) {
    List<FlSpot> spots = List<FlSpot>();
    dataModels.forEach((dataModel) {
      Memory memory = dataModel.memory;
      double memoryTotal = (memory.active / 1024 / 1024).floorToDouble();
      DateTime date = DateTime.parse(dataModel.at);
      spots.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), memoryTotal));
    });

    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [MyColors.green],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
    ];
  }

  Container buildRow(List<DataModel> dataModels) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: maxWight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MainPageItem(
              title: tr("using_CPU"),
              child: LineChart(
                chartData(linesCpuData(dataModels), isCPU: true),
                swapAnimationDuration: const Duration(milliseconds: 250),
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: MainPageItem(
              title: tr("memory_usage"),
              child: LineChart(
                chartData(linesMemoryData(dataModels)),
                swapAnimationDuration: const Duration(milliseconds: 250),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UptimeItem extends StatelessWidget {
  final Uptime uptime;
  final Function(String url) onDelete;

  const UptimeItem({
    Key key,
    this.onDelete,
    this.uptime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: MyColors.grey))),
      child: Row(
        children: [
          Expanded(
              child: Text(
            uptime.url,
            style: TextStyle(fontSize: 20),
          )),
          Text(
            tr("checks", args: [uptime.allChecks]),
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            tr("successful", args: [uptime.up]),
          ),
          FlatButton(
              onPressed: () => onDelete(uptime.url),
              child: Icon(
                Icons.delete_outline,
                color: MyColors.red,
              ))
        ],
      ),
    );
  }
}

class HostItem extends StatelessWidget {
  final String title;
  final Function(int) onSelected;
  final int id;
  final int currentId;
  final Function(int) onDelete;

  const HostItem({
    Key key,
    @required this.title,
    this.onSelected,
    this.id,
    this.currentId,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: id == currentId ? MyColors.green.withAlpha(20) : null,
          border: Border(bottom: BorderSide(color: MyColors.grey))),
      child: Row(
        children: [
          Expanded(
              child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  onPressed: () => onSelected(id),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 20),
                  ))),
          FlatButton(
              onPressed: () => onDelete(id),
              child: Icon(
                Icons.delete_outline,
                color: MyColors.red,
              ))
        ],
      ),
    );
  }
}

class MainPageItem extends StatelessWidget {
  final String title;
  final String content;
  final Widget child;

  const MainPageItem({
    Key key,
    this.title,
    this.content,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 30),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      height: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            title,
            maxLines: 2,
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 30),
            child: child,
          )),
        ],
      ),
    );
  }
}
