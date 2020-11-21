import 'package:servelyzer/model/auth_model.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/model/hosts_model.dart';
import 'package:servelyzer/model/registration_model.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/model/users_model.dart';
import 'package:servelyzer/provider/provider.dart';

class Repository {
  final _provider = Provider();

  Future<DataListModel> getData(String host, String from, String to) =>
      _provider.getData(host, from, to);

  Future<ResponseModel> getAuth(AuthModel authModel) =>
      _provider.getAuth(authModel);

  Future<bool> deleteServer(String server) => _provider.deleteServer(server);

  Future<bool> addServer(String server) => _provider.addServer(server);

  Future<ResponseModel> clearAvatar(String login) =>
      _provider.clearAvatar(login);

  Future<ResponseModel> clearHosts(String login) => _provider.clearHosts(login);

  Future<ResponseModel> setFreeUser(String login) =>
      _provider.setFreeUser(login);

  Future<ResponseModel> setPremiumUser(String login) =>
      _provider.setPremiumUser(login);

  Future<HostsModel> getServers() => _provider.getServers();

  Future<ResponseModel> isLogin() => _provider.isLogin();

  Future<UsersModel> getUsers() => _provider.getUsers();

  Future<ResponseModel> logout() => _provider.logout();

  Future<ResponseModel> getResetPassword(String email) =>
      _provider.getResetPassword(email);

  Future<ResponseModel> setAvatar(String image) => _provider.setAvatar(image);

  Future<ResponseModel> getAvatar() => _provider.getAvatar();

  Future<ResponseModel> getRegistration(RegistrationModel registrationModel) =>
      _provider.getRegistration(registrationModel);
}
