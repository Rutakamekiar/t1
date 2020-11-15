import 'package:rxdart/rxdart.dart';
import 'package:servelyzer/bloc/base/bloc.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/model/users_model.dart';
import 'package:servelyzer/repository/repository.dart';

class AdminBloc extends Bloc {
  final _repository = Repository();

  final _logoutFetcher = PublishSubject<ResponseModel>();
  final _loginFetcher = PublishSubject<ResponseModel>();
  final _setAvatar = PublishSubject<ResponseModel>();
  final _getAvatar = PublishSubject<ResponseModel>();
  final _getUsers = PublishSubject<UsersModel>();

  final _clearAvatar = PublishSubject<ResponseModel>();
  final _clearHosts = PublishSubject<ResponseModel>();
  final _setFreeUser = PublishSubject<ResponseModel>();
  final _setPremiumUser = PublishSubject<ResponseModel>();

  Stream<ResponseModel> get login => _loginFetcher.stream;

  Stream<ResponseModel> get clearAvatar => _clearAvatar.stream;

  Stream<ResponseModel> get clearHosts => _clearHosts.stream;

  Stream<ResponseModel> get setFreeUser => _setFreeUser.stream;

  Stream<ResponseModel> get setPremiumUser => _setPremiumUser.stream;

  Stream<ResponseModel> get logout => _logoutFetcher.stream;

  Stream<ResponseModel> get avatar => _getAvatar.stream;

  Stream<ResponseModel> get newAvatar => _setAvatar.stream;

  Stream<UsersModel> get users => _getUsers.stream;

  usersFetcher() async {
    try {
      UsersModel usersModel = await _repository.getUsers();
      _getUsers.sink.add(usersModel);
    } catch (e) {
      _getUsers.sink.addError(e);
    }
  }

  clearAvatarFetcher(String login) async {
    try {
      ResponseModel responseModel = await _repository.clearAvatar(login);
      _clearAvatar.sink.add(responseModel);
    } catch (e) {
      _clearAvatar.sink.addError(e);
    }
  }

  clearHostsFetcher(String login) async {
    try {
      ResponseModel responseModel = await _repository.clearHosts(login);
      _clearHosts.sink.add(responseModel);
    } catch (e) {
      _clearHosts.sink.addError(e);
    }
  }

  setFreeUserFetcher(String login) async {
    try {
      ResponseModel responseModel = await _repository.setFreeUser(login);
      _setFreeUser.sink.add(responseModel);
    } catch (e) {
      _setFreeUser.sink.addError(e);
    }
  }

  setPremiumUserFetcher(String login) async {
    try {
      ResponseModel responseModel = await _repository.setPremiumUser(login);
      _setPremiumUser.sink.add(responseModel);
    } catch (e) {
      _setPremiumUser.sink.addError(e);
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

  logoutFetcher() async {
    try {
      ResponseModel isLogout = await _repository.logout();
      _logoutFetcher.sink.add(isLogout);
    } catch (e) {
      _logoutFetcher.sink.addError(e);
    }
  }

  @override
  void dispose() {
    _logoutFetcher.close();
    _clearAvatar.close();
    _clearHosts.close();
    _setFreeUser.close();
    _setPremiumUser.close();
    _loginFetcher.close();
    _setAvatar.close();
    _getAvatar.close();
    _getUsers.close();
  }
}
