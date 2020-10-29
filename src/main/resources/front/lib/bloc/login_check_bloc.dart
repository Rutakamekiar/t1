import 'package:rxdart/rxdart.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/repository/repository.dart';

import 'base/bloc.dart';

class LoginCheckBloc extends Bloc {
  final _repository = Repository();
  final _loginFetcher = PublishSubject<ResponseModel>();

  Stream<ResponseModel> get login => _loginFetcher.stream;

  loginFetcher() async {
    try {
      ResponseModel isLogin = await _repository.isLogin();
      _loginFetcher.sink.add(isLogin);
    } catch (e) {
      _loginFetcher.sink.addError(e);
    }
  }

  @override
  void dispose() {
    _loginFetcher.close();
  }
}
