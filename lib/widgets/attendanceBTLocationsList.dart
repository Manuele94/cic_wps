import 'package:cic_wps/models/calendarEvent.dart';
import 'package:cic_wps/providers/calendarEvents.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/attendanceBTLocation.dart';
import 'attendanceBTLocationCard.dart';

class AttendanceBTLocationsList extends StatefulWidget {
  AttendanceBTLocationsList({Key key}) : super(key: key);
  CalendarEvent _event;
  int _selectedIndex;

  // AttendanceBTLocationsList({@required this.event});

  @override
  _AttendanceBTLocationsListState createState() =>
      _AttendanceBTLocationsListState();
}

class _AttendanceBTLocationsListState extends State<AttendanceBTLocationsList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locations = AttendanceBTLocations().getLocations; //TODO APPARARE
    widget._event = Provider.of<CalendarEvent>(context);
    getIndexByLocation(widget._event, locations);

//TODO FUTURE BUILDER
    return Padding(
      // padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text(
              'LOCATIONS',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 16,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: locations.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == widget._selectedIndex) {
                    return AttendanceBTLocationCard(
                        isActive: true,
                        text: locations[index],
                        onTapAction: () =>
                            _buttonSelection(index, locations[index]));
                  } else {
                    return AttendanceBTLocationCard(
                        isActive: false,
                        text: locations[index],
                        onTapAction: () =>
                            _buttonSelection(index, locations[index]));
                  }
                  ;
                }),
          ),
        ],
      ),
    );
  }

  void _buttonSelection(int selectedIndex, String text) {
    setState(() {
      widget._selectedIndex = selectedIndex;
      widget._event.setEventLocation(text);
    });
  }

  void getIndexByLocation(CalendarEvent event, List<String> location) {
    widget._selectedIndex =
        location.indexWhere((element) => element == event.location);
  }
}
