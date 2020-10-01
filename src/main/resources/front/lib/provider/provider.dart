import 'dart:convert';

import 'package:http/http.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/utils/constants.dart';

class Provider {
  Client client = Client();

  Future<DataModel> getData(String host) async {
    Response response;
    if(Constants.test) {
      response = await client.get("https://run.mocky.io/v3/d5714041-4137-4fa7-ba3e-9fbd0af22b48");
    } else {
      response = await client.get("${Constants.url}getmsg?host=$host");
    }
    return DataModel.fromJson(json.decode(response.body));
  }

  Future<dynamic> getAuth(String host) async {
    final response = await client.get("${Constants.url}getmsg?host=$host");
    return json.decode(response.body);
  }
}
