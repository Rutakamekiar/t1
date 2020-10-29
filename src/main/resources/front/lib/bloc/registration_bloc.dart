import 'package:rxdart/rxdart.dart';
import 'package:servelyzer/model/registration_model.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/repository/repository.dart';

import 'base/bloc.dart';

class RegistrationBloc extends Bloc {
  final _repository = Repository();
  final _registrationFetcher = PublishSubject<ResponseModel>();

  Stream<ResponseModel> get registration => _registrationFetcher.stream;
  registrationFetcher(RegistrationModel registrationModel) async {
    try {
      var data = await _repository.getRegistration(registrationModel).timeout(Duration(seconds: 10));
      _registrationFetcher.sink.add(data);
    } catch (e) {
      _registrationFetcher.sink.addError(e);
    }
  }

  @override
  void dispose() {
    _registrationFetcher.close();
  }
}
