import 'package:cic_wps/models/calendarEvent.dart';
import 'package:cic_wps/providers/calendarEvents.dart';
import 'package:cic_wps/providers/selectedCalendarEventDate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceActionRow extends StatefulWidget {
  // AttendanceActionRow({Key key}) : super(key: key);
  CalendarEvent eventModified;
  Function(CalendarEvents provider, DateTime day, CalendarEvent eventMod)
      delete;
  Function(CalendarEvents provider, DateTime day, CalendarEvent eventMod) save;

  AttendanceActionRow(
      {@required this.eventModified,
      @required this.delete,
      @required this.save});

  @override
  _AttendanceActionRowState createState() => _AttendanceActionRowState();
}

class _AttendanceActionRowState extends State<AttendanceActionRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(height: 15),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Card(
                  shadowColor: Theme.of(context).accentColor,
                  elevation: 2,
                  child: FlatButton(
                    onPressed: (widget.eventModified.isEmpty())
                        ? null
                        : () => widget.delete,
                    child: Text(
                      "Delete Day",
                    ),
                    textColor: Colors.red,
                    // disabledColor: Colors.grey,
                    disabledTextColor: Colors.grey,
                  ),
                ),
                Card(
                  shadowColor: Theme.of(context).accentColor,
                  elevation: 2,
                  child: FlatButton(
                    onPressed: () => widget.save,
                    child: Text(
                      "Save Day",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ]),
        ],
      ),
    );
  }

  // void _modifyEvent() {
  //   widget.provider
  //       .modifyEventInEvents(widget.selectedDay, widget.eventModified);
  // }

  // void _deleteEvent() {
  //   if (widget.eventModified.isEmpty()) {
  //     widget.provider
  //         .deleteEventInEvents(widget.selectedDay, widget.eventModified);
  //   } else {
  //     return null;
  //   }
  // }
}
