import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  Calendar({Key key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController;
  Map<DateTime, List> _events = Map();
  List _selectedEvents;
  DateTime _selectedDay;
  DateTime _nowDate;

  @override
  void initState() {
    super.initState();
    _nowDate = DateTime.now();
    _selectedDay =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _calendarController = CalendarController();
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TableCalendar(
        calendarController: _calendarController,
        calendarStyle: CalendarStyle(
          todayColor: Colors.transparent,
          selectedColor: Theme.of(context).accentColor,
          markersColor: Colors.redAccent,
          todayStyle: TextStyle(fontWeight: FontWeight.w700),
          unavailableStyle:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          leftChevronIcon: Icon(Icons.keyboard_arrow_left,
              color: Theme.of(context).iconTheme.color),
          rightChevronIcon: Icon(Icons.keyboard_arrow_right,
              color: Theme.of(context).iconTheme.color),
          formatButtonVisible: false,
        ),
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        events: _events,
        onDaySelected: (date, events) {
          setState(() {
            _selectedEvents = events;
            _selectedDay = DateTime(date.year, date.month, date.day);
          });
        },
        startDay: _nowDate.subtract(Duration(days: 30)),
        endDay: _nowDate.add(Duration(days: 30)),
      ),
    );
  }
}
