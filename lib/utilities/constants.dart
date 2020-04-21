import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
