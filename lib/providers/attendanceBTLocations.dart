import 'package:flutter/material.dart';
import '../providers/attendanceBtLocation.dart';

class AttendanceBTLocations with ChangeNotifier {
  Map<String, List> _availableBTLocationss = {}; //TODO TEST
  //LIST Avrà per ogni codice [città,cliente,plant]

  void setEventsfromJson(Map<String, dynamic> parsedJson) {
    final list = parsedJson['d']['results'] as List;

    final localLocations =
        list.map((e) => AttendanceBtLocation.fromJson(e)).toList();

    localLocations.forEach((element) {
      _availableBTLocationss.update(element.getIdLocation, (exsistingElement) {
        exsistingElement
            .add([element.getCity, element.getCustomer, element.getPlant]);
        return exsistingElement;
      },
          ifAbsent: () => [
                element.getCity,
                element.getCustomer,
                element.getPlant
              ]); //NON modificare l'ordine
    });
  }

//GETTERS CLASSICI
  // List<String> get getLocations => availableBTLocations;

  String getLocationCityByID(String idLocation) {
    if (_availableBTLocationss.containsKey(idLocation)) {
      return _availableBTLocationss[idLocation]
          .first; //la città è la prima inserita
    } else {
      // return "City not definied";
      return "";
    }
  }

  String getLocationPlantByID(String idLocation) {
    if (_availableBTLocationss.containsKey(idLocation)) {
      return _availableBTLocationss[idLocation]
          .last; //la città è la seconda(nonchè ultima) inserita
    } else {
      return "";
    }
  }

  String getFormattedLocationAllInfoByID(String idLocation) {
    if (_availableBTLocationss.containsKey(idLocation)) {
      var app = _availableBTLocationss[idLocation];
      return app.first +
          " - " +
          app.last; //la città è la seconda(nonchè ultima) inserita
    } else {
      return "Info not available";
    }
  }

  String getKeyByLocation(Map<String, String> location) {
    String returnKey = "NotDefined";
    _availableBTLocationss.forEach((key, value) {
      String appCityValue = value.first;
      String appPlantValue = value.last;
      if (location["city"] == appCityValue &&
          location["plant"] == appPlantValue) {
        returnKey = key;
      }
    });
    return returnKey;
  }

  List<String> getAllLocationCities() {
    List<String> allCities = [];
    _availableBTLocationss.forEach((key, value) {
      String appCityValue = value.first;
      if (!allCities.contains(appCityValue)) {
        allCities.add(appCityValue);
      }
    });
    return allCities;
  }

  List<String> getAllLocationPlants() {
    List<String> allPlants = [];
    _availableBTLocationss.forEach((key, value) {
      String appPlantValue = value.last;
      if (!allPlants.contains(appPlantValue)) {
        allPlants.add(appPlantValue);
      }
    });
    return allPlants;
  }

  List getAllCustomerLocationsInfo() {
    List all = [];
    _availableBTLocationss.forEach((key, value) {
      String client = value[1]; //posizione intermedia per il customer;
      if (client == 'X') {
        all.add([value.first, value.last]);
      }
    });
    return all;
  }

  List getAllIBMLocationsInfo() {
    List all = [];
    _availableBTLocationss.forEach((key, value) {
      String client = value[1]; //posizione intermedia per il customer;
      if (client != 'X') {
        all.add([value.first, value.last]);
      }
    });
    return all;
  }

  List<String> getLocationPlantsByCity(String city) {
    List<String> allPlants = [];
    _availableBTLocationss.forEach((key, value) {
      List appValue = value;
      if (appValue.first == city) {
        allPlants.add(appValue.last);
      }
    });
    return allPlants;
  }
  // List<String> get getLocations => availableBTLocations;
  // List<Map<String,String>>  get getLocations => availableBTLocations;
}
