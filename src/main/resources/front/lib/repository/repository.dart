import 'package:servelyzer/model/auth_model.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/model/registration_model.dart';
import 'package:servelyzer/provider/provider.dart';

class Repository {
  final _provider = Provider();

  Future<DataModel> getData(String host) => _provider.getData(host);

  Future<bool> getAuth(AuthModel authModel) => _provider.getAuth(authModel);

  Future<bool> getResetPassword(String email) => _provider.getResetPassword(email);

  Future<bool> getRegistration(RegistrationModel registrationModel) =>
      _provider.getRegistration(registrationModel);
}
