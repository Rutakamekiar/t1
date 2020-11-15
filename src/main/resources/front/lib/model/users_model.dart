class UsersModel {
  UsersModel({
    this.result,
    this.message,
    this.users,
  });

  int result;
  String message;
  List<User> users;

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        result: json["result"],
        message: json["message"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class User {
  User({
    this.login,
    this.userStatus,
    this.verificationStatus,
    this.avatar,
  });

  String login;
  UserStatus userStatus;
  VerificationStatus verificationStatus;
  Avatar avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
        login: json["login"],
        userStatus: userStatusValues.map[json["user-status"]],
        verificationStatus:
            verificationStatusValues.map[json["verification-status"]],
        avatar: avatarValues.map[json["avatar"]],
      );

  Map<String, dynamic> toJson() => {
        "login": login,
        "user-status": userStatusValues.reverse[userStatus],
        "verification-status":
            verificationStatusValues.reverse[verificationStatus],
        "avatar": avatarValues.reverse[avatar],
      };
}

enum Avatar { EMPTY, NOT_EMPTY }

final avatarValues =
    EnumValues({"empty": Avatar.EMPTY, "not empty": Avatar.NOT_EMPTY});

enum UserStatus { FREE, PREMIUM }

final userStatusValues = EnumValues({"free": UserStatus.FREE, "premium": UserStatus.PREMIUM});

enum VerificationStatus { VERIFICATED, NOT_VERIFICATED }

final verificationStatusValues = EnumValues({
  "not verificated": VerificationStatus.NOT_VERIFICATED,
  "verificated": VerificationStatus.VERIFICATED
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
