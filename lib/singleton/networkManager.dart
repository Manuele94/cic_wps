import 'dart:io';

import 'package:cic_wps/models/calendarEvent.dart';
import 'package:cic_wps/providers/calendarEvents.dart';
import 'package:cic_wps/singleton/dbManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkManager {
  static final NetworkManager _singleton =
      NetworkManager._internal(); //istanza singleton

  factory NetworkManager() =>
      _singleton; //istanza restituita quando viene chiamata dall'esterno
  NetworkManager._internal(); //viene reso il costruttore disponibile all'esterno

  // var url =
  //     r"http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZWKS_PROJECT_001_SRV/ZWKS_MASTERDATA_LOGIN(ZUSERNAME='IT065216',ZAPP='WORKPLACE_STATUS')?$format=json";
  static const _kAuth = "Basic UkZDSU9TOm1hcmVrMTc=";

  // var urlG =
  //     r"http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZPROVA_TOKEN_SRV/ZWKS_ATTENDANCE_DAY";

  Map<String, String> headers = {};

  Future<bool> _getToken(String url) async {
    return await http
        .head(url, headers: {
          "authorization": _kAuth,
          "x-csrf-token": "Fetch",
          "content-type": "application/json",
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

  Future<http.Response> getAllAttendances(String fromDay) async {
    final dbUser = await DbManager.getData("user");
    final user = dbUser.first["username"]; //TODO
    //
    final day = fromDay.substring(0, 10).replaceAll('-', '');
    var url =
        "http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZPROVA_TOKEN_SRV/ZWKS_ATTENDANCE_DAY?\$filter=ZUSERNAME%20eq%20'$user'%20and%20ZDATA%20eq%20'$day?\$format=json'";

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

  Future<bool> postAttendance(CalendarEvent event) async {
    //TODO
    final dbUser = await DbManager.getData("user");

    Map<String, dynamic> parameter = {
      'd': {
        'ZUSERNAME': dbUser.first["username"],
        'ZDATA': event.date,
        'ZFESTIVO': event.holiday,
        'ZCAUSALE': event.motivation,
        'ZLUOGO': event.location,
        'ZNOTE': event.note,
      }
    };

    const url =
        r"http://sap-es.it.ibm.com:8121/sap/opu/odata/sap/ZPROVA_TOKEN_SRV/ZWKS_ATTENDANCE_DAY";
    var tokenResponse = await _getToken(url);
    if (tokenResponse) {
      return await http
          .post(url, body: json.encode(parameter), headers: headers)
          .then((response) {
        return _checkResponse(response);
      }).catchError((onError) {
        print(onError.toString());
      }).timeout(Duration(seconds: 10));
    } else {
      return false;
    }
  }

  bool _checkResponse(http.Response response) {
    if (response.statusCode >= 200 || response.statusCode <= 300) {
      return true;
    } else {
      return false;
    }
  }
}
