import 'dart:ui';

import 'package:cic_wps/models/calendarEvent.dart';
import 'package:cic_wps/models/snackBarMessage.dart';
import 'package:cic_wps/providers/calendarEvents.dart';
import 'package:cic_wps/providers/selectedCalendarEventDate.dart';
import 'package:cic_wps/singleton/networkManager.dart';
import 'package:cic_wps/utilities/attendanceTypeAb.dart';
import 'package:cic_wps/utilities/constants.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:cic_wps/widgets/attendanceBTLocationsList.dart';
import 'package:cic_wps/widgets/attendanceNoteForm.dart';
import 'package:cic_wps/widgets/attendanceTypeRow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/calendar.dart';

class EventDetailPage extends StatelessWidget {
  // const EventDetailPage({Key key}) : super(key: key);

  static const routeName = '/EventDetailPage';
  static const calendarFormat = CalendarFormat.week;
  final _nowDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    final _selectedDayProvider =
        Provider.of<SelectedCalendarEventDate>(context);
    final _eventsProvider = Provider.of<CalendarEvents>(context);
    final _selectedDay = _selectedDayProvider.getSelectedDay;
    List<CalendarEvent> _events =
        _eventsProvider.getEventCopyByDate(_selectedDay);
    CalendarEvent _eventToModify = _checkEvent(_events, _selectedDay);

    return ChangeNotifierProvider.value(
      value: _eventToModify,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: false,
              expandedHeight: 100,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'EventDetail',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline5.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () => _showDialog(context),
                  child: Text(
                    "Week Submit",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                )
              ],
            ),
            SliverToBoxAdapter(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Calendar(calendarFormat),
                Visibility(
                  visible: ((_selectedDay.isBefore(_nowDate)) ||
                      _eventsProvider.isHoliday(_selectedDay)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Text(
                        "Changes in the past or on Holiday are not allowed",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  replacement: Column(children: <Widget>[
                    SizedBox(height: 10),
                    AttendanceTypeRow(),
                    SizedBox(height: 10),
                    Consumer<CalendarEvent>(
                      builder: (_, eventToModify, __) => Column(
                        children: <Widget>[
                          Visibility(
                            visible: _changeLocationVisibility(eventToModify),
                            child: AttendanceBTLocationsList(),
                          ),
                          Visibility(
                              visible: _changeNoteVisibility(eventToModify),
                              child: AttendanceNoteForm()),
                        ],
                      ),
                    ),
                    Column(
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
                                  onPressed: (_deleteConditions(
                                          _selectedDay, _eventToModify))
                                      ? () => _deleteEvent(_eventsProvider,
                                          _selectedDay, _eventToModify, context)
                                      : null,
                                  child: Text(
                                    "Delete Day",
                                  ),
                                  textColor: Colors.red,
                                  disabledTextColor: Colors.grey,
                                ),
                              ),
                              Consumer<CalendarEvent>(
                                builder: (_, eventToModify, __) => Card(
                                  shadowColor: Theme.of(context).accentColor,
                                  elevation: 2,
                                  child: FlatButton(
                                    onPressed: (_saveConditions(
                                            _selectedDay, eventToModify))
                                        ? () => _modifyEvent(
                                            _eventsProvider,
                                            _selectedDay,
                                            eventToModify,
                                            context)
                                        : null,
                                    child: Text(
                                      "Save Day",
                                    ),
                                    textColor: Colors.green,
                                    disabledTextColor: Colors.grey,
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ]),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }

// Se nel giorno selezionato non c'è nessun evento bisgona crearne uno nuovo predisposto alla modifica
  CalendarEvent _checkEvent(
      List<CalendarEvent> calendarEvent, DateTime selectedDay) {
    if (calendarEvent.isEmpty) {
      return CalendarEvent(
          note: '',
          user: '',
          date: selectedDay.toString().substring(0, 10).replaceAll('-', ''),
          holiday: '',
          location: '',
          motivation: '');
    } else {
      return calendarEvent.first;
    }
  }

  bool _changeNoteVisibility(CalendarEvent event) {
    if (event.getMotivation.toString().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

//Le locations devono essere visibili sono con i businessTrip
  bool _changeLocationVisibility(CalendarEvent event) {
    if (event.getStructuredMotivation() == AttendanceTypeAb.BUSINESS_TRIP) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _modifyEvent(CalendarEvents provider, DateTime selDay,
      CalendarEvent modifiedEvent, BuildContext ctx) async {
    if (modifiedEvent.getLocation.isEmpty &&
        modifiedEvent.getStructuredMotivation() ==
            AttendanceTypeAb.BUSINESS_TRIP) {
      SnackBarMessage.genericError(ctx, "Please specify the location fields");
      return;
    }

    startLoadingSpinner(ctx);
    try {
      var resp = await provider.modifyEventInEvents(selDay, modifiedEvent);
      if (resp) {
        Navigator.pop(ctx);
        SnackBarMessage.successfullyAttendanceUpload(ctx);
      } else {
        Navigator.pop(ctx);
        SnackBarMessage.genericError(ctx, "Something went wrong!");
      }
    } catch (onError) {
      Navigator.pop(ctx);
      SnackBarMessage.genericError(ctx, onError.toString());
    }
  }

  Future<void> _deleteEvent(CalendarEvents provider, DateTime selDay,
      CalendarEvent modifiedEvent, BuildContext ctx) async {
    startLoadingSpinner(ctx);
    try {
      var resp = await provider.deleteEventInEvents(selDay, modifiedEvent);
      if (resp) {
        Navigator.pop(ctx);
        SnackBarMessage.successfullyAttendanceDeleted(ctx);
      } else {
        Navigator.pop(ctx);
        SnackBarMessage.genericError(ctx, "Something went wrong!");
      }
    } catch (onError) {
      Navigator.pop(ctx);
      SnackBarMessage.genericError(ctx, onError.toString());
    }
  }

  void _showDialog(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text("Pay Attention!", style: TextStyle(color: Colors.red)),
        content: Text(
          "You will convalidate the week that ends on the ${_calculateLastWeekDayDate(_nowDate)}",
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText(
              "Upload",
            ),
            onPressed: () {
              _uploadWeekConfirmation(context);

              Navigator.of(context).pop();
            },
          ),
          PlatformDialogAction(
            child: PlatformText(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        ios: (_) => CupertinoAlertDialogData(
          content: Text(
            "You will convalidate the week that ends on the ${_calculateLastWeekDayDate(_nowDate)}",
          ),
        ),
      ),
    );
  }

  String _calculateLastWeekDayDate(DateTime date) {
    var difference = 7 - date.weekday;
    return date.add(Duration(days: difference)).toString().substring(0, 10);
  }

  bool _deleteConditions(DateTime selectedDay, CalendarEvent eventToModify) {
    if (eventToModify.isEmpty() || selectedDay.isBefore(_nowDate)) {
      return false;
    } else {
      return true;
    }
  }

  bool _saveConditions(DateTime selectedDay, CalendarEvent eventToModify) {
    if (eventToModify.getMotivation.isEmpty || selectedDay.isBefore(_nowDate)) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _uploadWeekConfirmation(BuildContext ctx) async {
    var date = _nowDate.toString().substring(0, 10).replaceAll('-', '');
    var confirmation = CalendarEvent(
      date: date,
      holiday: "",
      location: "",
      motivation: "VALID",
      note: "",
      user: "",
    );

    try {
      var response = await NetworkManager().postAttendance(confirmation);
      if (response) {
        Navigator.pop(ctx);
        SnackBarMessage.successfullyAttendanceUpload(ctx);
      } else {
        Navigator.pop(ctx);
        SnackBarMessage.genericError(ctx, "Something went wrong!");
      }
    } catch (e) {
      SnackBarMessage.genericError(ctx, e.toString());
    }
  }
}
