import 'package:rxdart/rxdart.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/model/hosts_model.dart';
import 'package:servelyzer/repository/repository.dart';

import 'base/bloc.dart';

class MainBloc extends Bloc {
  final _repository = Repository();
  final _dataFetcher = PublishSubject<DataListModel>();
  final _serversFetcher = PublishSubject<HostsModel>();

  final _deleteFetcher = PublishSubject<bool>();
  final _addFetcher = PublishSubject<bool>();

  Stream<DataListModel> get data => _dataFetcher.stream;
  Stream<HostsModel> get servers => _serversFetcher.stream;
  Stream<bool> get delete => _deleteFetcher.stream;
  Stream<bool> get add => _addFetcher.stream;

  dataFetcher(String host, String from, String to) async {
    try {
      DataListModel dataListModel = await _repository.getData(host, from, to);
      if(dataListModel.result == 0){
        throw Exception(dataListModel.message);
      } else {
        _dataFetcher.sink.add(dataListModel);
      }
    } catch (e) {
      _dataFetcher.sink.addError(e);
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
    _serversFetcher.close();
    _deleteFetcher.close();
    _addFetcher.close();
    _dataFetcher.close();
  }
}