class UserDB {
  int _id;
  String _username;
  bool _sUser;
  String _password;

  UserDB(this._id, this._username, this._sUser, this._password);

  int get id => _id;
  String get username => _username;
  bool get s_user => _sUser;
  String get password => _password;

  set username(String username) {
    if (username != null) {
      _username = username;
    }
  }

  set sUser(bool s_user) {
    if (s_user != null) {
      _sUser = s_user;
    }
  }

  set password(String password) {
    if (password != null) {
      _password = password;
    }
  }

  // funzione per convertire l'oggetto in map
  Map<String, dynamic> toMap(UserDB userDB) {
    var map = Map<String, dynamic>();

    if (id != null) {
      map["id"] = _id;
    }
    map["username"] = _username;
    map["sUser"] = _sUser;
    map["password"] = _password;

    return map;
  }

  //funzione inversa
  UserDB toUserDB(Map<String, dynamic> map) {
    this._id = map["id"];
    this._username = map["username"];
    this._sUser = map["sUser"];
    this._password = map["password"];
  }
}
