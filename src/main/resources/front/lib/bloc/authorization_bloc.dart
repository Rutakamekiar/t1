import 'package:rxdart/rxdart.dart';
import 'package:servelyzer/model/auth_model.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/repository/repository.dart';

import 'base/bloc.dart';

class AuthorizationBloc extends Bloc {
  final _repository = Repository();
  final _authFetcher = PublishSubject<ResponseModel>();

  Stream<ResponseModel> get auth => _authFetcher.stream;

  authFetcher(AuthModel authModel) async {
    try {
      ResponseModel data = await _repository.getAuth(authModel);
      _authFetcher.sink.add(data);
    } catch (e) {
      _authFetcher.sink.addError(e);
    }
  }

  @override
  void dispose() {
    _authFetcher.close();
  }
}
