import 'package:dio/dio.dart';
import 'package:servelyzer/model/auth_model.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/model/hosts_model.dart';
import 'package:servelyzer/model/registration_model.dart';
import 'package:servelyzer/model/response_model.dart';
import 'package:servelyzer/model/users_model.dart';
import 'package:servelyzer/utils/constants.dart';

class Provider {
  Dio dio = Dio();

  Future<DataListModel> getData(String host, String from, String to) async {
    print("${Constants.url}getmsg?public_key=$host&from=$from&to=$to");
    final response =
        await dio.get("${Constants.url}getmsg?public_key=$host&from=$from&to=$to");
    return DataListModel.fromJson(response.data);
  }

  Future<ResponseModel> getAuth(AuthModel authModel) async {
    try {
      FormData formData = new FormData.fromMap(authModel.toMap());
      final response = await dio.post("${Constants.url}signin", data: formData);
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<UsersModel> getUsers() async {
    try {
      final response = await dio.post("${Constants.url}getallusersadmin");
      return UsersModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseModel> setAvatar(String image) async {
    try {
      final response = await dio.post("${Constants.url}setavatar", data: image);
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseModel> getAvatar() async {
    try {
      final response = await dio.get("${Constants.url}getavatar");
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseModel> logout() async {
    try {
      final response = await dio.post(
        "${Constants.url}logout",
      );
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw (e);
    }
  }

  Future<ResponseModel> isLogin() async {
    try {
      final response = await dio.get(
        "${Constants.url}isLogin",
      );
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> deleteServer(String server) async {
    try {
      final response =
          await dio.delete("${Constants.url}deleteServer?public_key=$server");
      print(response.data);
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> addServer(String server) async {
    try {
      final response = await dio.put("${Constants.url}addServer?public_key=$server");
      print(response.data);
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<HostsModel> getServers() async {
    try {
      final response = await dio.get("${Constants.url}getServers");
      return HostsModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseModel> getRegistration(
      RegistrationModel registrationModel) async {
    print("${Constants.url}register?login=${registrationModel.login}"
        "&email=${registrationModel.email}&pwd=${registrationModel.pwd}");
    try {
      final response = await dio.post(
        "${Constants.url}register?login=${registrationModel.login}"
        "&email=${registrationModel.email}&pwd=${registrationModel.pwd}",
      );
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw (e);
    }
  }

  Future<ResponseModel> getResetPassword(String email) async {
    print("${Constants.url}droppwd?email=$email");
    try {
      final response = await dio.post(
        "${Constants.url}droppwd?email=$email",
      );
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw (e);
    }
  }
}
