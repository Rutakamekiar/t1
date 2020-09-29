import 'package:rxdart/rxdart.dart';
import 'package:servelyzer/repository/repository.dart';

import 'base/bloc.dart';

class MainBloc extends Bloc {
  final _repository = Repository();
  final _dataFetcher = PublishSubject<dynamic>();

  Stream<dynamic> get data => _dataFetcher.stream;

  dataFetcher(String host) async {
    try {
       var data = await _repository.getData(host);
       _dataFetcher.sink.add(data);
    } catch (e) {
      _dataFetcher.sink.addError(e);
    }
  }

  @override
  void dispose() {
    _dataFetcher.close();
  }
}