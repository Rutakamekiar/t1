class HostsModel {
  HostsModel({this.hosts, this.message, this.result});

  List<Host> hosts;
  String message;
  int result;

  factory HostsModel.fromJson(Map<String, dynamic> json) => HostsModel(
        result: json["result"] ?? 1,
        message: json["message"],
        hosts: json["hosts"] == null
            ? null
            : List<Host>.from(json["hosts"].map((x) => Host.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hosts": List<dynamic>.from(hosts.map((x) => x.toJson())),
      };
}

class Host {
  Host({
    this.host,
  });

  String host;

  factory Host.fromJson(Map<String, dynamic> json) => Host(
        host: json["host"],
      );

  Map<String, dynamic> toJson() => {
        "host": host,
      };
}
