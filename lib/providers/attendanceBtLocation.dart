import 'dart:core';
import 'package:flutter/material.dart';

class AttendanceBtLocation with ChangeNotifier {
  String idLocation;
  final String city;
  final String plant;
  final String customer;

  AttendanceBtLocation({
    required this.idLocation,
    required this.city,
    required this.plant,
    required this.customer,
  });

  //GETTERS CLASSICI
  String get getIdLocation => idLocation.isNotEmpty ? idLocation : "";
  String get getCity => city.isNotEmpty ? city : "";
  String get getPlant => plant.isNotEmpty ? plant : "";
  String get getCustomer => customer.isNotEmpty ? customer : "";

  factory AttendanceBtLocation.fromJson(Map<String, dynamic> parsedJson) {
    return AttendanceBtLocation(
      idLocation: parsedJson["ZID_LOCATION"],
      city: parsedJson["BEZEI"],
      plant: parsedJson["ZPLANT"],
      customer: parsedJson["ZCLIENTE"],
    );
  }

  void setIdLocation(String id) {
    this.idLocation = id;
    notifyListeners();
  }
}
