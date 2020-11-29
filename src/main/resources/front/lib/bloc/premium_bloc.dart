import 'package:rxdart/rxdart.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/repository/repository.dart';

import 'base/bloc.dart';

class PremiumBloc extends Bloc {
  final _repository = Repository();
  final _premiumFetcher = PublishSubject<ResponseModel>();

  Stream<ResponseModel> get premium => _premiumFetcher.stream;

  getPremium(String code) async {
    try {
      ResponseModel responseModel = await _repository.getPremium(code);
      _premiumFetcher.sink.add(responseModel);
    } catch (e) {
      _premiumFetcher.sink.addError(e);
    }
  }

  @override
  void dispose() {
    _premiumFetcher.close();
  }
}
