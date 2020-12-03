class ResponseModel {
  ResponseModel({this.result, this.message, this.user, this.userStatus});

  int result;
  String message;
  String user;
  String userStatus;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
      result: json["result"] ?? 1,
      message: json["message"],
      user: json["user"],
      userStatus: json["user-status"]);

  Map<String, dynamic> toJson() =>
      {"result": result, "message": message, "user": user};
}
