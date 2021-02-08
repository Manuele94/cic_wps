import 'package:cic_wps/providers/calendarEvent.dart';
import 'package:cic_wps/providers/calendarEvents.dart';
import 'package:cic_wps/providers/selectedCalendarEventDate.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  // Calendar({Key key}) : super(key: key);
  CalendarFormat calendarFormat;

  Calendar(this.calendarFormat);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final CalendarController _calendarController = CalendarController();
  // Map<DateTime, List> _events = Map();
  // List _selectedEvents;
  DateTime _selectedDay;
  final DateTime _nowDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // _nowDate = DateTime.now();
    // _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    // _calendarController = CalendarController();
    // _selectedEvents = _events[_selectedDay] ?? [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _calendarController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _events = Provider.of<CalendarEvents>(context).getEvents;
    final _holidays = Provider.of<CalendarEvents>(context).getHolidays;
    final selectedDayProvider = Provider.of<SelectedCalendarEventDate>(context);
    _selectedDay = selectedDayProvider.getSelectedDay;

    return TableCalendar(
        calendarController: _calendarController,
        calendarStyle: CalendarStyle(
          todayColor: Colors.transparent,
          selectedColor: Theme.of(context).accentColor,
          // markersColor: Theme.of(context).accentColor,
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
        availableCalendarFormats: {
          widget.calendarFormat: _getCalendarFormatString(widget.calendarFormat)
        },
        initialCalendarFormat: widget.calendarFormat,
        events: _events,
        holidays: _holidays,
        onDaySelected: (date, events) {
          selectedDayProvider.selectDay(date);
        },
        initialSelectedDay: _selectedDay,
        startDay: _nowDate.subtract(Duration(days: 30)),
        endDay: _nowDate.add(Duration(days: 90)),
        builders: CalendarBuilders(
          singleMarkerBuilder: (context, date, event) {
            CalendarEvent app = event;
            return Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: app.getColorByMotivation()),
              width: 7.0,
              height: 7.0,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
            );
          },
        ));
  }

  String _getCalendarFormatString(CalendarFormat cF) {
    switch (cF) {
      case CalendarFormat.month:
        return 'Month';
      case CalendarFormat.week:
        return 'Week';
      case CalendarFormat.twoWeeks:
        return '2 weeks';
      default:
        return 'Month';
    }
  }
}
