import 'package:servelyzer/provider/provider.dart';

class Repository {
  final _provider = Provider();

  Future<dynamic> getData(String host) => _provider.getData(host);
  Future<dynamic> getAuth(String host) => _provider.getAuth(host);

}