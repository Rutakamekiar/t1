class ResponseModel {
  ResponseModel({
    this.result,
    this.message,
  });

  int result;
  String message;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        result: json["result"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
      };
}
