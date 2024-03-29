import 'dart:io';

import 'package:cic_wps/providers/attendanceBtLocation.dart';
import 'package:cic_wps/providers/calendarEvent.dart';
import 'package:xml2json/xml2json.dart';
import 'package:cic_wps/singleton/dbManager.dart';
import 'package:cic_wps/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkManager {
  static final NetworkManager _singleton =
      NetworkManager._internal(); //istanza singleton

  factory NetworkManager() =>
      _singleton; //istanza restituita quando viene chiamata dall'esterno
  NetworkManager._internal(); //viene reso il costruttore disponibile all'esterno

  final xmlConverter = Xml2Json();

  static const _kAuth = "Basic UkZDSU9TOm1hcmVrMTc=";

  Map<String, String> headers = {};

  Future<bool> _getToken(String url) async {
    return await http
        .head(url, headers: {
          "authorization": _kAuth,
          "x-csrf-token": "Fetch",
          "content-type": "application/json",
          "accept": "application/json",
        })
        .catchError((onError) {
          print(onError.toString());
        })
        .timeout(Duration(seconds: 10))
        .then((response) {
          _updateCookie(response);
          return _checkResponse(response);
        });
  }

  void _updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    String token = response.headers['x-csrf-token'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(',') + 1;
      headers['cookie'] = rawCookie.substring(index, rawCookie.length);
      headers['x-csrf-token'] = token;
      headers['content-type'] = "application/json";
    }
  }

  Future<http.Response> getForLogin(Map<String, String> _authData) async {
    // final dbUser = await DbManager.getData("user");
    // final user = dbUser.first["username"]; //TODO
    var user = _authData["id"];
    var psw = _authData["psw"];
    var url =
        "http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZNAP_LOGIN_SRV/Login_Set(ZUSERNAME='$user',ZAPP='WORKPLACE_STATUS',ZVERSIONE='$kVers',ZPASSWORD='$psw')";
    // var url =
    //     "http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZNAP_LOGIN_SRV/Login_Set_2?\$filter=ZUSERNAME%20eq%20'$user'%20and%ZAPP%20eq%20'WORKPLACE_STATUS'%20and%ZVERSIONE%20eq%20'$kVers'%20and%ZPASSWORD%20eq%20'$psw?\$format=json";
    return await http
        .get(url, headers: {
          "authorization": _kAuth,
          "Accept": "application/json",
        })
        .then((response) {
          return response;
        })
        .timeout(Duration(seconds: 20))
        .catchError((onError) {
          print(onError.toString());
        });
  }

  Future<http.Response> getAllAttendances(String fromDay) async {
    final dbUser = await DbManager.getData("user");
    var user = dbUser.first["username"]; //TODO
    //
    final day = fromDay.substring(0, 10).replaceAll('-', '');
    // var url =
    //     "http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZPROVA_TOKEN_SRV/ZWKS_ATTENDANCE_DAY?\$filter=ZUSERNAME%20eq%20'$user'%20and%20ZDATA%20eq%20'$day?\$format=json'";
    var url =
        "http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZNAP_ATTENDANCE_SRV/Attendance_New_Set?\$filter=ZUSERNAME%20eq%20'$user'%20and%20ZDATA%20eq%20'$day?\$format=json'";

    return await http
        .get(url, headers: {
          "authorization": _kAuth,
          "Accept": "application/json",
        })
        .then((response) {
          return response;
        })
        .timeout(Duration(seconds: 10))
        .catchError((onError) {
          print(onError.toString());
        });
  }

  Future<http.Response> getAllLocations() async {
    final dbUser = await DbManager.getData("user");
    var user = dbUser.first["username"];

    var url =
        "http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZNAP_LOCATION_SRV/Location_Set?\$filter=ZUSERNAME%20eq%20'$user'";

    return await http
        .get(url, headers: {
          "authorization": _kAuth,
          "Accept": "application/json",
        })
        .then((response) {
          return response;
        })
        .timeout(Duration(seconds: 20))
        .catchError((onError) {
          print(onError.toString());
        });
  }

  Future<http.Response> getForCredentials(String mail) async {
    var url =
        "http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZNAP_RECORDING_SRV/Recording_Set(ZEMAIL='$mail')";

    return await http
        .get(url, headers: {
          "authorization": _kAuth,
          "Accept": "application/json",
        })
        .then((response) {
          return response;
        })
        .timeout(Duration(seconds: 20))
        .catchError((onError) {
          print(onError.toString());
        });
  }

  Future<http.Response> postAttendance(CalendarEvent event) async {
    //TODO
    final dbUser = await DbManager.getData("user");

    Map<String, dynamic> parameter = {
      'd': {
        'ZUSERNAME': dbUser.first["username"],
        'ZDATA': event.date,
        'ZFESTIVO': event.holiday,
        'ZCAUSALE': event.motivation,
        'ZID_LOCATION': event.location,
        'ZNOTE': event.note,
      }
    };

    const url =
        r"http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZNAP_ATTENDANCE_SRV/Attendance_New_Set";
    var tokenResponse = await _getToken(url);
    if (tokenResponse) {
      headers.addAll({
        "accept": "application/json",
      });
      return await http
          .post(url, body: json.encode(parameter), headers: headers)
          .then((response) {
        print(response.body);
        return response;
      }).catchError((onError) {
        print(onError.toString());
      }).timeout(Duration(seconds: 10));
    } else {
      return http.Response("", 400);
    }
  }

  Future<http.Response> postLocationOfBelonging(
      AttendanceBtLocation location) async {
    //TODO
    final dbUser = await DbManager.getData("user");

    Map<String, dynamic> parameter = {
      'd': {
        'ZUSERNAME': dbUser.first["username"],
        'ZID_LOCATION': location.getIdLocation,
      }
    };

    const url =
        r"http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZNAP_LOCATION_SRV/New_Location_Set?\$format=json";
    var tokenResponse = await _getToken(url);
    if (tokenResponse) {
      headers.addAll({
        "accept": "application/json",
      });
      return await http
          .post(url, body: json.encode(parameter), headers: headers)
          .then((response) {
        print(response.body);
        return response;
      }).catchError((onError) {
        print(onError.toString());
      }).timeout(Duration(seconds: 10));
    } else {
      return http.Response("", 400);
    }
  }

//QUESTO E' IL PRIMO STEP DELLA REGISTRAZIONE. INVIO MAIL CON PASSWORD MOMENTANEA
  Future<http.Response> getForRegistration(String email) async {
    var url =
        "http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZNAP_RECORDING_SRV/Create_Set(ZEMAIL='$email')";

    return await http
        .get(url, headers: {
          "authorization": _kAuth,
          "Accept": "application/json",
        })
        .then((response) {
          return response;
        })
        .timeout(Duration(seconds: 20))
        .catchError((onError) {
          print(onError.toString());
        });
  }

//QUESTO E' IL SECONDO STEP DELLA REGISTRAZIONE. CAMBIO CON PASSWORD MOMENTANEA
  Future<http.Response> getForRegistrationTemp(
      Map<String, String> _authData) async {
    // final dbUser = await DbManager.getData("user");
    // final user = dbUser.first["username"]; //TODO
    var user = _authData["id"];
    var psw = _authData["psw"];
    var url =
        "http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZNAP_LOGIN_SRV/Login_Initial_Set(ZUSERNAME='$user',ZAPP='WORKPLACE_STATUS',ZVERSIONE='$kVers',ZPASSWORD='$psw')";
    // var url =
    //     "http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZNAP_LOGIN_SRV/Login_Set_2?\$filter=ZUSERNAME%20eq%20'$user'%20and%ZAPP%20eq%20'WORKPLACE_STATUS'%20and%ZVERSIONE%20eq%20'$kVers'%20and%ZPASSWORD%20eq%20'$psw?\$format=json";
    return await http
        .get(url, headers: {
          "authorization": _kAuth,
          "Accept": "application/json",
        })
        .then((response) {
          return response;
        })
        .timeout(Duration(seconds: 20))
        .catchError((onError) {
          print(onError.toString());
        });
  }

  Future<http.Response> postForPswUpdate(Map<String, String> _authData) async {
    var user = _authData["id"];
    var psw = _authData["psw"];

    Map<String, dynamic> parameter = {
      'd': {
        'ZUSERNAME': user,
        'ZPASSWORD': psw,
        'ZAPP': "WORKPLACE_STATUS",
        "ZVERSIONE": kVers,
      }
    };
    const url =
        r"http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZNAP_LOGIN_SRV/Login_Set";
    var tokenResponse = await _getToken(url);
    if (tokenResponse) {
      headers.addAll({
        "accept": "application/json",
      });
      return await http
          .post(url, body: json.encode(parameter), headers: headers)
          .then((response) {
        return response;
      }).catchError((onError) {
        print(onError.toString());
        return http.Response("", 400);
      }).timeout(Duration(seconds: 10));
    } else {
      return http.Response("", 400);
    }
  }

  bool _checkResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return true;
    } else {
      return false;
    }
  }
}
