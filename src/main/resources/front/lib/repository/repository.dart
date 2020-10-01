import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/provider/provider.dart';

class Repository {
  final _provider = Provider();

  Future<DataModel> getData(String host) => _provider.getData(host);
  Future<dynamic> getAuth(String host) => _provider.getAuth(host);

}