import 'package:rxdart/rxdart.dart';
import 'package:servelyzer/repository/repository.dart';

import 'base/bloc.dart';

class AuthorizationBloc extends Bloc {
  final _repository = Repository();
  final _authFetcher = PublishSubject<dynamic>();

  Stream<dynamic> get auth => _authFetcher.stream;

  authFetcher(String host) async {
    try {
      var data = await _repository.getAuth(host);
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