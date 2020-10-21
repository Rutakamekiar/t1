class RegistrationModel {
  String login;
  String email;
  String pwd;

  RegistrationModel(this.login, this.email, this.pwd);

  Map<String, dynamic> toMap() => {
    "login": login,
    "email": email,
    "pwd": pwd,
  };
}