import 'dart:convert';

import 'package:http/http.dart';
import 'package:servelyzer/utils/constants.dart';

class Provider {
  Client client = Client();

  Future<dynamic> getData(String host) async {
    final response = await client.get("${Constants.url}getmsg?host=$host");
    return json.decode(response.body);
  }

  Future<dynamic> getAuth(String host) async {
    final response = await client.get("${Constants.url}getmsg?host=$host");
    return json.decode(response.body);
  }
}
