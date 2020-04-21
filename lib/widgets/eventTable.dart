import 'package:flutter/material.dart';
import '../widgets/eventTableItem.dart';
import '../models/calendarEvent.dart';
import 'package:provider/provider.dart';
import 'package:cic_wps/providers/calendarEvents.dart';
import 'package:cic_wps/providers/selectedCalendarEventDate.dart';

class EventTable extends StatefulWidget {
  EventTable({Key key}) : super(key: key);

  @override
  _EventTableState createState() => _EventTableState();
}

class _EventTableState extends State<EventTable> {
  @override
  Widget build(BuildContext context) {
    var selectedDayProvider = Provider.of<SelectedCalendarEventDate>(context);
    var _selectedDay = selectedDayProvider.getSelectedDay;
    List<CalendarEvent> _events = Provider.of<CalendarEvents>(context)
        .getAllEventsCopyByDate(_selectedDay);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _defineTitle(_events),
        Column(
          children: _events
              .map((event) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EventTableItem(
                      event: event,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _defineTitle(List<CalendarEvent> events) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 100, 8, 0),
          child: Text(
            'You have no plans for today!',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          'Selected Events',
          style: TextStyle(
            color: Theme.of(context).textTheme.headline5.color,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
