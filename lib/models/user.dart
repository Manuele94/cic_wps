class User {
  final String username;
  final String app;
  final String company;
  final String surname;
  final String name;
  final String region;
  final String office;
  final bool sUser;
  final String osSystem;
  final String version;
  String password;

  User(
      {this.username,
      this.app,
      this.company,
      this.surname,
      this.name,
      this.region,
      this.office,
      this.password,
      this.sUser,
      this.osSystem,
      this.version});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      username: parsedJson["d"]["ZUSERNAME"],
      app: parsedJson["d"]["ZAPP"],
      company: parsedJson["d"]["ZSOCIETA"],
      surname: parsedJson["d"]["ZCOGNOME"],
      name: parsedJson["d"]["ZNOME"],
      region: parsedJson["d"]["ZREGIONE"],
      office: parsedJson["d"]["ZSEDE"],
      password: parsedJson["d"]["ZPASSWORD"],
      sUser: parsedJson["d"]["ZSUPER_USER"],
      osSystem: parsedJson["d"]["ZOS_CHIAMANTE"],
      version: parsedJson["d"]["ZVERSIONE"],
    );
  }

//  set setPassword(String password){
//    this.password = password;
//  }

  void setPassword(String password) {
    this.password = password;
  }
}
