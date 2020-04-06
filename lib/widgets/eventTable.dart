import 'package:flutter/material.dart';
import '../widgets/eventTableItem.dart';
import '../models/eventDate.dart';

class EventTable extends StatefulWidget {
  EventTable({Key key}) : super(key: key);

  @override
  _EventTableState createState() => _EventTableState();
}

class _EventTableState extends State<EventTable> {
//TODO PROVA ITEM
  final List<EventDate> tableItems = [
    EventDate(
        note: "note",
        user: "user",
        date: "01012001",
        holiday: "Holiday",
        location: "location",
        motivation: "motivation"),
    EventDate(
        note: "note2",
        user: "user2",
        date: "01012001",
        holiday: "Holiday",
        location: "location",
        motivation: "motivation"),
    EventDate(
        note: "note2",
        user: "user2",
        date: "01012001",
        holiday: "Holiday",
        location: "location",
        motivation: "motivation"),
    EventDate(
        note: "note2",
        user: "user2",
        date: "01012001",
        holiday: "Holiday",
        location: "location",
        motivation: "motivation"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      // children: <Widget>[
      // ListView.builder(
      // padding: const EdgeInsets.all(8.0),
      // itemCount: tableItems.length,
      // itemBuilder: (ctx, i) => ListTile(),
      // ),
      // ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: tableItems
          .map((element) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: EventTableItem(
                    eventType: element.motivation,
                    location: element.getLocation,
                    description: element.getNote),
              ))
          .toList(),
    );
  }
}
