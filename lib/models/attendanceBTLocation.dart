import 'package:flutter/material.dart';

class AttendanceBTLocations {
  List<String> availableBTLocations = [
    "Milan",
    "Bergamo",
    "Rome",
    "Naples",
    "Brindisi"
  ]; //TODO TEST
  // mettere final

  // AttendanceBTLocations({
  //   @required this.availableBTLocations,
  // });

  // factory AttendanceBTLocations.fromJson(Map<String, dynamic> parsedJson) {
  //   return new AttendanceBTLocations(
  //     availableBTLocations: parsedJson["ZLOCATIONS"],//TODO APPARARE
  //   );
  // }

//GETTERS CLASSICI
  List<String> get getLocations => availableBTLocations;
}
