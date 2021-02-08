import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../utilities/attendanceTypeAb.dart';

class CalendarEvent with ChangeNotifier {
  String note;
  final String user;
  final String date;
  final String holiday;
  String location;
  String motivation;

  CalendarEvent({
    required this.note,
    required this.user,
    required this.date,
    required this.holiday,
    required this.location,
    required this.motivation,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> parsedJson) {
    return new CalendarEvent(
      note: parsedJson["ZNOTE"],
      user: parsedJson["ZUSERNAME"],
      date: parsedJson["ZDATA"],
      holiday: parsedJson["ZFESTIVO"],
      location: parsedJson["ZID_LOCATION"],
      motivation: parsedJson["ZCAUSALE"],
    );
  }

//GETTERS CLASSICI
  String get getNote => note.isNotEmpty ? note : "";
  String get getUser => user.isNotEmpty ? user : "";
  String get getDate => date.isNotEmpty ? date : "";
  String get getHoliday => holiday.isNotEmpty ? holiday : "";
  String get getLocation => location.isNotEmpty ? location : "";
  String get getMotivation => motivation.isNotEmpty ? motivation : "";

  bool isEmpty() {
    if (this.note.isEmpty &&
        this.user.isEmpty &&
        // event.date.isEmpty       ||
        this.holiday.isEmpty &&
        this.location.isEmpty &&
        this.motivation.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool isNotEmpty() {
    if (this.note.isNotEmpty &&
        this.user.isNotEmpty &&
        // event.date.isEmpty       ||
        this.holiday.isNotEmpty &&
        this.location.isNotEmpty &&
        this.motivation.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool hasNoLocation() {
    if (this.note.isEmpty &&
        this.user.isEmpty &&
        // event.date.isEmpty       ||
        this.holiday.isEmpty &&
        // this.location.isEmpty &&
        this.motivation.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  CalendarEvent getCopy() {
    return new CalendarEvent(
        note: this.getNote,
        user: this.getUser,
        date: this.date,
        holiday: this.holiday,
        location: this.location,
        motivation: this.motivation);
  }

//*****MOTIVATION*****
//DEFINISCO UNO STANDARD PER GESTIRE LA STRINGA CHE MI PASSANO
//PER NON USARE STRINGHE IN GIRO PER L'APP
  AttendanceTypeAb getStructuredMotivation() {
    switch (this.motivation) {
      case "Absence":
        return AttendanceTypeAb.ABSENCE;
        break;
      case "Remote Working":
        return AttendanceTypeAb.REMOTE_WORKING;
        break;
      case "Business Trip":
        return AttendanceTypeAb.BUSINESS_TRIP;
        break;
      default:
        return AttendanceTypeAb.NOT_DEFINED;
    }
  }

  // String _getDestructuredMotivation(AttendanceTypeAb newMotivation) {
  //   switch (newMotivation) {
  //     case AttendanceTypeAb.ABSENCE:
  //       return "A";
  //       break;
  //     case AttendanceTypeAb.REMOTE_WORKING:
  //       return "R";
  //       break;
  //     case AttendanceTypeAb.BUSINESS_TRIP:
  //       return "T";
  //       break;
  //     default:
  //       return "ND";
  //   }
  // }

//PER COLLEGARE IN MODO CENTRALIZZATO UN ICONA AL TIPO "ASSENZA"
  IconData getIconByMotivation() {
    if (itHoliday()) return getIconIfItsHoliday();

    switch (getStructuredMotivation()) {
      case AttendanceTypeAb.ABSENCE:
        return LineIcons.sun_o;
        break;
      case AttendanceTypeAb.REMOTE_WORKING:
        return LineIcons.home;
        break;
      case AttendanceTypeAb.BUSINESS_TRIP:
        return LineIcons.suitcase;
        break;
      case AttendanceTypeAb.NOT_DEFINED:
        return LineIcons.question;
        break;
      default:
        return LineIcons.question;
    }
  }

  Color getColorByMotivation() {
    if (itHoliday()) return getColorIfItsHoliday();

    switch (getStructuredMotivation()) {
      case AttendanceTypeAb.ABSENCE:
        return Colors.blue;
        break;
      case AttendanceTypeAb.REMOTE_WORKING:
        return Colors.orange;
        break;
      case AttendanceTypeAb.BUSINESS_TRIP:
        return Colors.indigo;
        break;
      case AttendanceTypeAb.NOT_DEFINED:
        return Colors.white;
        break;
      default:
        return Colors.white;
    }
  }

//PER COLLEGARE IN MODO CENTRALIZZATO UNA STRINGA AL TIPO "ASSENZA"
  String getTextByMotivation() {
    if (itHoliday()) return getTextIfItsHoliday();
    switch (getStructuredMotivation()) {
      case AttendanceTypeAb.ABSENCE:
        return AttendanceTypeAb.ABSENCE.value.toString();
        break;
      case AttendanceTypeAb.REMOTE_WORKING:
        return AttendanceTypeAb.REMOTE_WORKING.value.toString();
        break;
      case AttendanceTypeAb.BUSINESS_TRIP:
        return AttendanceTypeAb.BUSINESS_TRIP.value.toString();
        break;
      case AttendanceTypeAb.NOT_DEFINED:
        return AttendanceTypeAb.NOT_DEFINED.value.toString();
        break;
      default:
        return AttendanceTypeAb.NOT_DEFINED.value.toString();
    }
  }

//FUNZIONE PER CONVERTIRE ID LOCATION IN LOCATION

  // String getConvertedLocationById(String id) {}

//FUNZIONE PER CAMBIARE IL CAMPO MOTIVAZIONE DELL'EVENTO
  void setEventMotivation(AttendanceTypeAb newMotivation) {
    if (newMotivation == null) {
      return;
    } else {
      // if (newMotivation != AttendanceTypeAb.BUSINESS_TRIP) {
      //   location = ""; //
      // }
      this.motivation = newMotivation.value;
      notifyListeners();
    }
  }

//FUNZIONE PER CAMBIARE IL CAMPO NOTE DELL'EVENTO
  void setEventNote(String newNote) {
    if (newNote == null || newNote.isEmpty) {
      return;
    } else {
      this.note = newNote;
    }
  }

//FUNZIONE PER CAMBIARE IL CAMPO NOTE DELL'EVENTO
  void setEventLocation(String newLocation) {
    if (newLocation == null || newLocation.isEmpty) {
      return;
    } else {
      this.location = newLocation;
    }
  }

// FUNZIONE UTILE PER PULIRE LA LOCATION
  void clearLocation() {
    this.location = "";
  }

  bool itHoliday() {
    if (holiday.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //
  String getTextIfItsHoliday() {
    return AttendanceTypeAb.HOLIDAY.value.toString();
  }

  Color getColorIfItsHoliday() {
    return Colors.red;
  }

  IconData getIconIfItsHoliday() {
    return LineIcons.hotel;
  }
}
