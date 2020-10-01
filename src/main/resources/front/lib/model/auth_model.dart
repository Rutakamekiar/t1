class AuthModel {
  String username;
  String password;

  AuthModel(this.username, this.password);

  Map<String, dynamic> toMap() => {
    "username": username,
    "password": password,
  };
}