import 'package:rxdart/rxdart.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/repository/repository.dart';

import 'base/bloc.dart';

class ResetPasswordBloc extends Bloc {
  final _repository = Repository();
  final _resetPasswordFetcher = PublishSubject<ResponseModel>();

  Stream<ResponseModel> get resetPassword => _resetPasswordFetcher.stream;

  resetPasswordFetcher(String email) async {
    try {
      var data = await _repository.getResetPassword(email).timeout(Duration(seconds: 10));
      _resetPasswordFetcher.sink.add(data);
    } catch (e) {
      _resetPasswordFetcher.sink.addError(e);
    }
  }

  @override
  void dispose() {
    _resetPasswordFetcher.close();
  }
}
