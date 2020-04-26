import 'package:cic_wps/models/snackBarMessage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SapReturnMessage {
  final String code;
  final String message;

  SapReturnMessage({
    this.code,
    this.message,
  });

  factory SapReturnMessage.fromJson(Map<String, dynamic> parsedJson) {
    return SapReturnMessage(
      code: parsedJson["d"]["ZTP_MESSAGE"],
      message: parsedJson["d"]["ZMESSAGE"],
    );
  }

//GETTERS CLASSICI
  String get getCode => code;
  String get getMessage => message;

  Flushbar returnSnackByMessage(BuildContext context) {
    switch (code) {
      case 'S':
        return SnackBarMessage.genericSuccess(context, this.message);
        break;
      case 'I':
        return SnackBarMessage.genericInfo(context, this.message);
        break;
      case 'E':
        return SnackBarMessage.genericError(context, this.message);
        break;
    }
  }
}
