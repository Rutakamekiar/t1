class UptimeModel {
  UptimeModel({
    this.result,
    this.message,
    this.uptime,

  });

  int result;
  String message;
  List<Uptime> uptime;

  factory UptimeModel.fromJson(Map<String, dynamic> json) => UptimeModel(
    result: json["result"] ?? 1,
    message: json["message"],
    uptime: json["uptime"] != null ? List<Uptime>.from(json["uptime"].map((x) => Uptime.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "uptime": List<dynamic>.from(uptime.map((x) => x.toJson())),
  };
}

class Uptime {
  Uptime({
    this.url,
    this.allChecks,
    this.up,
  });

  String url;
  String allChecks;
  String up;

  factory Uptime.fromJson(Map<String, dynamic> json) => Uptime(
    url: json["url"],
    allChecks: json["all_checks"],
    up: json["up"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "all_checks": allChecks,
    "up": up,
  };
}
