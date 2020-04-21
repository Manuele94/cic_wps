import 'package:flutter/material.dart';

class SelectedCalendarEventDate with ChangeNotifier {
  DateTime _selectedCalendarEventDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void selectDay(DateTime day) {
    _selectedCalendarEventDate =  DateTime(day.year, day.month, day.day);
    notifyListeners();
  }

  DateTime get getSelectedDay {
    return _selectedCalendarEventDate;
  }
}
