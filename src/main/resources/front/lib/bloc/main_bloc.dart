import 'package:rxdart/rxdart.dart';
import 'package:servelyzer/model/UptimeModel.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/model/hosts_model.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/repository/repository.dart';

import 'base/bloc.dart';

class MainBloc extends Bloc {
  final _repository = Repository();
  final _dataFetcher = PublishSubject<DataListModel>();
  final _serversFetcher = PublishSubject<HostsModel>();

  final _deleteFetcher = PublishSubject<bool>();
  final _addFetcher = PublishSubject<bool>();
  final _logoutFetcher = PublishSubject<ResponseModel>();
  final _loginFetcher = PublishSubject<ResponseModel>();
  final _setAvatar = PublishSubject<ResponseModel>();
  final _getAvatar = PublishSubject<ResponseModel>();

  final _getUptimeFetcher = PublishSubject<UptimeModel>();
  final _addUrlFetcher = PublishSubject<ResponseModel>();
  final _deleteUrlFetcher = PublishSubject<ResponseModel>();

  Stream<DataListModel> get data => _dataFetcher.stream;

  Stream<HostsModel> get servers => _serversFetcher.stream;

  Stream<bool> get delete => _deleteFetcher.stream;

  Stream<bool> get add => _addFetcher.stream;

  Stream<UptimeModel> get uptime => _getUptimeFetcher.stream;

  Stream<ResponseModel> get addUrlStream => _addUrlFetcher.stream;

  Stream<ResponseModel> get deleteUrlStream => _deleteUrlFetcher.stream;

  Stream<ResponseModel> get avatar => _getAvatar.stream;

  Stream<ResponseModel> get logout => _logoutFetcher.stream;

  Stream<ResponseModel> get newAvatar => _setAvatar.stream;

  Stream<ResponseModel> get login => _loginFetcher.stream;

  dataFetcher(String host, String from, String to) async {
    try {
      DataListModel dataListModel = await _repository.getData(host, from, to);
      if (dataListModel.result == 0) {
        throw Exception(dataListModel.message);
      } else {
        _dataFetcher.sink.add(dataListModel);
      }
    } catch (e) {
      _dataFetcher.sink.addError(e);
    }
  }

  addUrl(String url) async {
    try {
      ResponseModel responseModel = await _repository.addUrl(url);
      _addUrlFetcher.sink.add(responseModel);
    } catch (e) {
      _addUrlFetcher.sink.addError(e);
    }
  }

  deleteUrl(String url) async {
    try {
      ResponseModel responseModel = await _repository.deleteUrl(url);
      _deleteUrlFetcher.sink.add(responseModel);
    } catch (e) {
      _deleteUrlFetcher.sink.addError(e);
    }
  }

  getUptime() async {
    try {
      UptimeModel uptimeModel = await _repository.getUptime();
      _getUptimeFetcher.sink.add(uptimeModel);
    } catch (e) {
      _getUptimeFetcher.sink.addError(e);
    }
  }

  setAvatar(String image) async {
    try {
      ResponseModel avatar = await _repository.setAvatar(image);
      _setAvatar.sink.add(avatar);
    } catch (e) {
      _setAvatar.sink.addError(e);
    }
  }

  getAvatar() async {
    try {
      ResponseModel avatar = await _repository.getAvatar();
      _getAvatar.sink.add(avatar);
    } catch (e) {
      _getAvatar.sink.addError(e);
    }
  }

  loginFetcher() async {
    try {
      ResponseModel isLogin = await _repository.isLogin();
      _loginFetcher.sink.add(isLogin);
    } catch (e) {
      _loginFetcher.sink.addError(e);
    }
  }

  logoutFetcher() async {
    try {
      ResponseModel isLogout = await _repository.logout();
      _logoutFetcher.sink.add(isLogout);
    } catch (e) {
      _logoutFetcher.sink.addError(e);
    }
  }

  getServers() async {
    try {
      HostsModel hostsModel = await _repository.getServers();
      _serversFetcher.sink.add(hostsModel);
    } catch (e) {
      _serversFetcher.sink.addError(e);
    }
  }

  deleteServer(String server) async {
    try {
      bool deleted = await _repository.deleteServer(server);
      _deleteFetcher.sink.add(deleted);
    } catch (e) {
      _deleteFetcher.sink.addError(e);
    }
  }

  addServer(String server) async {
    try {
      bool added = await _repository.addServer(server);
      _addFetcher.sink.add(added);
    } catch (e) {
      _addFetcher.sink.addError(e);
    }
  }

  @override
  void dispose() {
    _setAvatar.close();
    _getAvatar.close();
    _getUptimeFetcher.close();
    _deleteUrlFetcher.close();
    _addUrlFetcher.close();
    _deleteFetcher.close();
    _serversFetcher.close();
    _deleteFetcher.close();
    _logoutFetcher.close();
    _loginFetcher.close();
    _addFetcher.close();
    _dataFetcher.close();
  }
}
