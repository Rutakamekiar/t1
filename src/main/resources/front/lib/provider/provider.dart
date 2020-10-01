import 'package:dio/dio.dart';
import 'package:servelyzer/model/auth_model.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/utils/constants.dart';

class Provider {
  Dio dio = Dio();

  Future<DataModel> getData(String host) async {
    Response response;
    if(Constants.test) {
      response = await dio.get("https://run.mocky.io/v3/d5714041-4137-4fa7-ba3e-9fbd0af22b48");
    } else {
      response = await dio.get("${Constants.url}getmsg?host=$host");
    }
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
}
