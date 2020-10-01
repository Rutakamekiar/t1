import 'package:rxdart/rxdart.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/repository/repository.dart';

import 'base/bloc.dart';

class MainBloc extends Bloc {
  final _repository = Repository();
  final _dataFetcher = PublishSubject<DataModel>();

  Stream<DataModel> get data => _dataFetcher.stream;

  dataFetcher(String host) async {
    try {
      DataModel dataModel = await _repository.getData(host);
      if(dataModel.result == 0){
        throw Exception(dataModel.message);
      } else {
        _dataFetcher.sink.add(dataModel);
      }
    } catch (e) {
      _dataFetcher.sink.addError(e);
    }
  }

  @override
  void dispose() {
    _dataFetcher.close();
  }
}