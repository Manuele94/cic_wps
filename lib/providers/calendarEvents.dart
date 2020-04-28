import 'package:cic_wps/singleton/networkManager.dart';
import 'package:cic_wps/utilities/attendanceTypeAb.dart';

import '../models/calendarEvent.dart';
import 'package:flutter/material.dart';

class CalendarEvents with ChangeNotifier {
  Map<DateTime, List> _events = {};
  Map<DateTime, List> _holidays = {};

  //TODO TEST

// converto il risultato in una lista
// mappo la lista come un insieme di CalendarEvent e per ognuno di questi
// popolo il mio modello _events. Se c'è già un elemento con quella chiave
// ne aggiungo un altro per quella chiave. Se non c'è la chiave inserisco il primo
  void setEventsfromJson(Map<String, dynamic> parsedJson) {
    final list = parsedJson['d']['results'] as List;

    final localEvents = list.map((e) => CalendarEvent.fromJson(e)).toList();

    localEvents.forEach((element) {
      var dataParsed = DateTime.parse(element.getDate);
      if (element.holiday.isEmpty) {
        _events.update(dataParsed, (exsistingElement) {
          exsistingElement.add(element);
          return exsistingElement;
        }, ifAbsent: () => [element]);
      } else {
        _holidays.update(dataParsed, (exsistingElement) {
          exsistingElement.add(element);
          return exsistingElement;
        }, ifAbsent: () => [element]);
      }
      ;
    });
    notifyListeners();
  }

//getter evento by date. Viene restituita una copia.
//Se ci sono eventi già inseriti per quella giornata, questi vengono restituiti
//altrimenti bisogna predisporre l'inserimento di un nuovo elemento
  List<CalendarEvent> getEventCopyByDate(DateTime selectedDate) {
    //TODO APPARARE
    // in dart gli oggetti custom vengon passati solo per riferimento
    // a differenza dei tipi primitivi. Quindi per passare una copia cisi
    // deve muovere in questo modo
    if (_events.containsKey(selectedDate)) {
      var copyListDate = _events[selectedDate];
      var copyList = List<CalendarEvent>.generate(
          copyListDate.length,
          (index) => CalendarEvent(
              note: copyListDate[index].getNote,
              user: copyListDate[index].getUser,
              date: copyListDate[index].getDate,
              holiday: copyListDate[index].getHoliday,
              location: copyListDate[index].getLocation,
              motivation: copyListDate[index].getMotivation));
      return copyList;
    } else {
      List<CalendarEvent> emptyList = [];
      return [...emptyList];
    }
  }

//getter holiday by date. Viene restituita una copia.
//Se ci sono eventi già inseriti per quella giornata, questi vengono restituiti
//altrimenti bisogna predisporre l'inserimento di un nuovo elemento
  List<CalendarEvent> getHolidayCopyByDate(DateTime selectedDate) {
    //TODO APPARARE
    // in dart gli oggetti custom vengon passati solo per riferimento
    // a differenza dei tipi primitivi. Quindi per passare una copia cisi
    // deve muovere in questo modo
    if (_holidays.containsKey(selectedDate)) {
      var copyListDate = _holidays[selectedDate];
      var copyList = List<CalendarEvent>.generate(
          copyListDate.length,
          (index) => CalendarEvent(
              note: copyListDate[index].getNote,
              user: copyListDate[index].getUser,
              date: copyListDate[index].getDate,
              holiday: copyListDate[index].getHoliday,
              location: copyListDate[index].getLocation,
              motivation: copyListDate[index].getMotivation));
      return copyList;
    } else {
      List<CalendarEvent> emptyList = [];
      return [...emptyList];
    }
  }

  List<CalendarEvent> getAllEventsCopyByDate(DateTime selectedDate) {
    //TODO APPARARE
    // in dart gli oggetti custom vengon passati solo per riferimento
    // a differenza dei tipi primitivi. Quindi per passare una copia cisi
    // deve muovere in questo modo
    Map<DateTime, List> allEvents = {};
    allEvents.addAll(_events);
    allEvents.addAll(_holidays);
    if (allEvents.containsKey(selectedDate)) {
      var copyListDate = allEvents[selectedDate];
      var copyList = List<CalendarEvent>.generate(
          copyListDate.length,
          (index) => CalendarEvent(
              note: copyListDate[index].getNote,
              user: copyListDate[index].getUser,
              date: copyListDate[index].getDate,
              holiday: copyListDate[index].getHoliday,
              location: copyListDate[index].getLocation,
              motivation: copyListDate[index].getMotivation));
      return copyList;
    } else {
      List<CalendarEvent> emptyList = [];
      return [...emptyList];
    }
  }

//getter per tutti gli eventi.
  Map<DateTime, List> get getEvents {
    return {..._events};
  }

//getter Holidays
  Map<DateTime, List> get getHolidays {
    return {..._holidays};
  }

//Funzione finalizzata alla modifica di un evento specifico
// tenendo sempre conto che per ogni giornata è previsto un solo evento
  Future<bool> modifyEventInEvents(
      DateTime selectedDate, CalendarEvent event) async {
    return await NetworkManager().postAttendance(event).then((value) {
      if (value) {
        _events.addAll({
          selectedDate: [event]
        });
        notifyListeners();
        return true;
      } else {
        return false;
      }
    }).catchError((onError) {
      print(onError.toString());
      return false;
    });
  }

//Funzione finalizzata alla cancellazione di un evento specifico
// tenendo sempre conto che per ogni giornata è previsto un solo evento
  Future<bool> deleteEventInEvents(
      DateTime selectedDate, CalendarEvent event) async {
    event.setEventMotivation(
        AttendanceTypeAb.FLAG_CANCELLAZIONE); //flag cancellazione per sap
    return await NetworkManager().postAttendance(event).then((value) {
      if (value && _events.containsKey(selectedDate)) {
        _events[selectedDate].clear();
        notifyListeners();
        return true;
      } else {
        return false;
      }
    });
  }

  bool isHoliday(DateTime selectedDate) {
    return _holidays.containsKey(selectedDate);
  }
}
