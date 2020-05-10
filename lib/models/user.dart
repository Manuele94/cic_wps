class User {
  final String username;
  final String app;
  // final bool sUser;
  final String osSystem;
  final String version;
  String password;
  String locationOfBelonging;
  // final SapReturnMessage message;

  User({
    this.username,
    this.app,
    this.password,
    // this.sUser,
    this.osSystem,
    this.version,
    this.locationOfBelonging,
    // this.message
  });

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    // var message = SapReturnMessage.fromJson(parsedJson);
    return User(
      username: parsedJson["d"]["ZUSERNAME"],
      app: parsedJson["d"]["ZAPP"],
      password: parsedJson["d"]["ZPASSWORD"],
      // sUser: parsedJson["d"]["ZSUPER_USER"],
      osSystem: parsedJson["d"]["ZOS_CHIAMANTE"],
      version: parsedJson["d"]["ZVERSIONE"],
      locationOfBelonging:
          parsedJson["d"]["BEZEI"] + " " + parsedJson["d"]["ZPLANT"],
      // message: message,
    );
  }

//  set setPassword(String password){
//    this.password = password;
//  }
  get getIdLocation => this.locationOfBelonging;

  void setPassword(String password) {
    this.password = password;
  }
}
