import 'package:flutter/material.dart';
import 'package:cic_wps/providers/calendarEvent.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '../utilities/attendanceTypeAb.dart';
import 'attendanceTypeCard.dart';

class AttendanceTypeRow extends StatefulWidget {
  // AttendanceTypeRow({Key key}) : super(key: key);
  CalendarEvent _event;
  bool firstButtonIsActive;
  bool secondButtonIsActive;
  bool thirdButtonIsActive;

  // AttendanceTypeRow({@required this.event});

  @override
  _AttendanceTypeRowState createState() => _AttendanceTypeRowState();
}

class _AttendanceTypeRowState extends State<AttendanceTypeRow> {
  @override
  Widget build(BuildContext context) {
    widget._event = Provider.of<CalendarEvent>(context);
    _initRow(widget._event);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Text(
            'ATTENDANCE TYPE',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              AttendanceTypeCard(
                  isActive: widget.firstButtonIsActive,
                  icon: LineIcons.sun_o,
                  text: AttendanceTypeAb.ABSENCE.value,
                  onTapAction: _firstButtonSelection),
              AttendanceTypeCard(
                  isActive: widget.secondButtonIsActive,
                  icon: LineIcons.home,
                  text: AttendanceTypeAb.REMOTE_WORKING.value,
                  onTapAction: _secondButtonSelection),
              AttendanceTypeCard(
                  isActive: widget.thirdButtonIsActive,
                  icon: LineIcons.suitcase,
                  text: AttendanceTypeAb.BUSINESS_TRIP.value,
                  onTapAction: thirdButtonSelection),
            ]),
      ],
    );
  }

  void _changeEventMotivation(AttendanceTypeAb newSelection) {
    widget._event.setEventMotivation(newSelection);
  }

  void _clearSelection() {
    widget.firstButtonIsActive = false;
    widget.secondButtonIsActive = false;
    widget.thirdButtonIsActive = false;
  }

  void _initRow(CalendarEvent event) {
    _clearSelection();
    switch (event.getStructuredMotivation()) {
      case AttendanceTypeAb.ABSENCE:
        widget.firstButtonIsActive = true;
        break;
      case AttendanceTypeAb.REMOTE_WORKING:
        widget.secondButtonIsActive = true;
        break;
      case AttendanceTypeAb.BUSINESS_TRIP:
        widget.thirdButtonIsActive = true;
        break;
      case AttendanceTypeAb.NOT_DEFINED:
        _clearSelection();
    }
  }

  void _firstButtonSelection() {
    setState(() {
      _clearSelection();
      widget.firstButtonIsActive = true;
      _changeEventMotivation(AttendanceTypeAb.ABSENCE);
    });
  }

  void _secondButtonSelection() {
    setState(() {
      _clearSelection();
      widget.secondButtonIsActive = true;
      _changeEventMotivation(AttendanceTypeAb.REMOTE_WORKING);
    });
  }

  void thirdButtonSelection() {
    setState(() {
      _clearSelection();
      widget.thirdButtonIsActive = true;
      _changeEventMotivation(AttendanceTypeAb.BUSINESS_TRIP);
    });
  }
}
