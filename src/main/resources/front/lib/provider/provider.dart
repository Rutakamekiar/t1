import 'package:dio/dio.dart';
import 'package:servelyzer/model/UptimeModel.dart';
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
    final response = await dio
        .get("${Constants.url}getmsg?public_key=$host&from=$from&to=$to");
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

  Future<ResponseModel> clearAvatar(String login) async {
    try {
      final response =
          await dio.post("${Constants.url}admindropavatar?login=$login");
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseModel> clearHosts(String login) async {
    try {
      final response =
          await dio.post("${Constants.url}dropuserhosts?login=$login");
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseModel> setFreeUser(String login) async {
    try {
      final response =
          await dio.post("${Constants.url}adminsetfree?login=$login");
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseModel> setPremiumUser(String login) async {
    try {
      final response =
          await dio.post("${Constants.url}adminsetpremium?login=$login");
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<UsersModel> getUsers() async {
    try {
      final response = await dio.get("${Constants.url}getallusersadmin");
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

  Future<ResponseModel> deleteUrl(String url) async {
    try {
      final response = await dio.post(
        "${Constants.url}deleteUrl?url=$url",
      );
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw (e);
    }
  }

  Future<ResponseModel> getPremium(String code) async {
    try {
      final response = await dio.post(
        "${Constants.url}getPremium?code=$code",
      );
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw (e);
    }
  }

  Future<ResponseModel> addUrl(String url) async {
    try {
      final response = await dio.post(
        "${Constants.url}addUrl?url=$url",
      );
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw (e);
    }
  }

  Future<UptimeModel> getUptime() async {
    try {
      final response = await dio.get(
        "${Constants.url}getUptime",
      );
      return UptimeModel.fromJson(response.data);
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
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseModel> addServer(String publicKey, String privateKey) async {
    try {
      final response =
          await dio.put("${Constants.url}addServer?public_key=$publicKey&private_key=$privateKey");
      return ResponseModel.fromJson(response.data);
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
      RegistrationModel registrationModel, String lang) async {
    try {
      final response = await dio.post(
        "${Constants.url}registerWithLoc?login=${registrationModel.login}"
        "&email=${registrationModel.email}&pwd=${registrationModel.pwd}"
        "&lang=$lang",
      );
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw (e);
    }
  }

  Future<ResponseModel> getResetPassword(String email, String lang) async {
    try {
      final response = await dio.post(
        "${Constants.url}droppwdWithLoc?email=$email"
        "&lang=$lang",
      );
      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw (e);
    }
  }
}
