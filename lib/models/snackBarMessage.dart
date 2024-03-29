import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'dart:io' show Platform;

class SnackBarMessage {
  static Flushbar wrongPasswordLogin(BuildContext context) {
    return Flushbar(
      title: "Ops!",
      message: "Wrong Password!",
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      margin: EdgeInsets.all(8),

      isDismissible: true,
      duration: const Duration(seconds: 2),
      backgroundGradient:
          LinearGradient(colors: [Colors.red, Colors.redAccent]),
      //boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 1.0)],
    )..show(context);
  }

  static Flushbar genericError(BuildContext context, String message) {
    return Flushbar(
      title: "Ops!",
      message: message,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      margin: EdgeInsets.all(8),

      isDismissible: true,
      duration: const Duration(seconds: 3),
      backgroundGradient:
          LinearGradient(colors: [Colors.red, Colors.redAccent]),
      //boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 1.0)],
    )..show(context);
  }

  static Flushbar genericSuccess(BuildContext context, String message) {
    return Flushbar(
      title: "Great!",
      message: message,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      margin: EdgeInsets.all(8),

      isDismissible: true,
      duration: const Duration(seconds: 3),
      backgroundGradient:
          LinearGradient(colors: [Colors.green, Colors.greenAccent]),
      //boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 1.0)],
    )..show(context);
  }

  static Flushbar genericInfo(BuildContext context, String message) {
    return Flushbar(
      title: "Hey!",
      message: message,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      margin: EdgeInsets.all(8),

      isDismissible: true,
      duration: const Duration(seconds: 3),
      backgroundGradient:
          LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
      //boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 1.0)],
    )..show(context);
  }

  static Flushbar obsoleteVersionInfo(BuildContext context, String message) {
    return Flushbar(
      title: "Obsolete Version!",
      message: "Check TestFlight for iOS.\nTap Download for Android",
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      margin: EdgeInsets.all(8),
      mainButton: FlatButton(
        onPressed: () async {
          if (await canLaunch(message)) launch(message);
        },
        child: Text(
          "Dowload",
          style: TextStyle(color: Colors.white),
        ),
      ),

      isDismissible: true,
      duration: const Duration(seconds: 7),
      backgroundGradient:
          LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
      //boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 1.0)],
    )..show(context);
  }

  static Flushbar successfullyAttendanceUpload(BuildContext context) {
    return Flushbar(
      title: "Ok!",
      message: "Uploaded succesfully!",
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      margin: EdgeInsets.all(8),

      isDismissible: true,
      duration: const Duration(seconds: 1),
      backgroundGradient:
          LinearGradient(colors: [Colors.green, Colors.greenAccent]),
      //boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 1.0)],
    )..show(context);
  }

  static Flushbar successfullyRegistrationRequest(BuildContext context) {
    return Flushbar(
      title: "Registration request sent successfully!",
      message: "You will receive the response as soon as possible",
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      margin: EdgeInsets.all(8),

      isDismissible: true,
      duration: const Duration(seconds: 3),
      backgroundGradient:
          LinearGradient(colors: [Colors.green, Colors.greenAccent]),
      //boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 1.0)],
    )..show(context);
  }

  static Flushbar successfullyAttendanceDeleted(BuildContext context) {
    return Flushbar(
      title: "Ok!",
      message: "Cancellation Done!",
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      margin: EdgeInsets.all(8),

      isDismissible: true,

      duration: const Duration(seconds: 1),
      backgroundGradient:
          LinearGradient(colors: [Colors.green, Colors.greenAccent]),
      //boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 1.0)],
    )..show(context);
  }

  static Flushbar successfullyConfirmationUpload(BuildContext context) {
    return Flushbar(
      title: "Ok!",
      message: "Confirmation Done!",
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      margin: EdgeInsets.all(8),

      isDismissible: true,

      duration: const Duration(seconds: 1),
      backgroundGradient:
          LinearGradient(colors: [Colors.green, Colors.greenAccent]),
      //boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 1.0)],
    )..show(context);
  }
}
