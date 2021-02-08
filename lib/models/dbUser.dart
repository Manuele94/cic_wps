import 'package:flutter/material.dart';

class UserDB with ChangeNotifier {
  int _id;
  String _username;
  bool _sUser;
  String _password;
  String _locationOfBelonging;

  UserDB(this._id, this._username, this._sUser, this._password,
      this._locationOfBelonging);

  int get id => _id;
  String get username => _username;
  bool get s_user => _sUser;
  String get password => _password;
  String get idLocation => _locationOfBelonging;

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

  set idLocation(String location) {
    if (location != null) {
      _locationOfBelonging = location;
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
    map["userLocation"] = _locationOfBelonging;

    return map;
  }

  //funzione inversa
  // UserDB toUserDB(Map<String, dynamic> map) {
  //   this._id = map["id"];
  //   this._username = map["username"];
  //   this._sUser = map["sUser"];
  //   this._password = map["password"];
  //   this._locationOfBelonging = map["userLocation"];
  // }
}
