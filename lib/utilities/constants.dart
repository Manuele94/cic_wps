import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';

const loaderSpinner = SpinKitChasingDots(
  color: Colors.white,
  size: 50.0,
);

Future<dynamic> startLoadingSpinner(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return loaderSpinner;
      },
      barrierDismissible: false);
}

InputDecoration idInputDecoration(BuildContext ctx) {
  return InputDecoration(
    prefixIcon: Icon(
      LineIcons.user,
      color: Colors.grey.shade500,
    ),
    labelStyle: TextStyle(color: Theme.of(ctx).accentColor),
    hintText: "Username",
    hintStyle: TextStyle(color: Colors.grey),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade500),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Theme.of(ctx).accentColor),
    ),
  );
}

InputDecoration pswInputDecoration(BuildContext ctx) {
  return InputDecoration(
    prefixIcon: Icon(
      LineIcons.lock,
      color: Colors.grey.shade500,
    ),
    labelStyle: TextStyle(color: Theme.of(ctx).accentColor),
    hintText: "Password",
    hintStyle: TextStyle(color: Colors.grey),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade500),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Theme.of(ctx).accentColor),
    ),
  );
}

const kVers = "ET";
