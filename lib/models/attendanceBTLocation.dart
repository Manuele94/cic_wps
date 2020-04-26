import 'dart:core';
import 'package:flutter/material.dart';

class AttendanceBtLocation {
  final String idLocation;
  final String city;
  final String plant;

  AttendanceBtLocation({
    @required this.idLocation,
    @required this.city,
    @required this.plant,
  });

  //GETTERS CLASSICI
  String get getIdLocation => idLocation.isNotEmpty ? idLocation : "";
  String get getCity => city.isNotEmpty ? city : "";
  String get getPlant => plant.isNotEmpty ? plant : "";

  factory AttendanceBtLocation.fromJson(Map<String, dynamic> parsedJson) {
    return AttendanceBtLocation(
      idLocation: parsedJson["ZID_LOCATION"],
      city: parsedJson["BEZEI"],
      plant: parsedJson["ZPLANT"],
    );
  }
}
