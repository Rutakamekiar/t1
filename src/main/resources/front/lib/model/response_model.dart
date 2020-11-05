class ResponseModel {
  ResponseModel({this.result, this.message, this.user});

  int result;
  String message;
  String user;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
      result: json["result"], message: json["message"], user: json["user"]);

  Map<String, dynamic> toJson() =>
      {"result": result, "message": message, "user": user};
}
