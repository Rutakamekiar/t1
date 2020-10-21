import 'package:dio/dio.dart';
import 'package:servelyzer/model/auth_model.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/model/registration_model.dart';
import 'package:servelyzer/utils/constants.dart';

class Provider {
  Dio dio = Dio();

  Future<DataModel> getData(String host) async {
    Response response;
    response = await dio.get("${Constants.url}getmsg?host=$host");
    return DataModel.fromJson(response.data);
  }

  Future<bool> getAuth(AuthModel authModel) async {
    FormData formData = new FormData.fromMap(authModel.toMap());
    final response = await dio.post("${Constants.url}signin", data: formData);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getRegistration(RegistrationModel registrationModel) async {
    print( "${Constants.url}register?login=${registrationModel.login}"
        "&email=${registrationModel.email}&pwd=${registrationModel.pwd}");
    final response = await dio.get(
      "${Constants.url}register?login=${registrationModel.login}"
      "&email=${registrationModel.email}&pwd=${registrationModel.pwd}",
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getResetPassword(String email) async {
    print( "${Constants.url}droppwd?email=$email");
    final response = await dio.get("${Constants.url}droppwd?email=$email",);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
