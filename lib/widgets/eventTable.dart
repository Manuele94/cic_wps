import 'package:flutter/material.dart';
import '../models/eventTableItem.dart';

class EventTable extends StatefulWidget {
  EventTable({Key key}) : super(key: key);

  @override
  _EventTableState createState() => _EventTableState();
}

class _EventTableState extends State<EventTable> {
//TODO PROVA ITEM
  final List<EventTableItem> tableItems = [
    EventTableItem(
        eventType: "Transfert",
        location: "Milan",
        description: "annanannaannana"),
    EventTableItem(
        eventType: "Transfert",
        location: "Milan",
        description: "annanannaannana")
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Card(
        //   margin: const EdgeInsets.all(15),
        //   child: Padding(
        // padding: EdgeInsets.all(8),
        ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: tableItems.length,
          itemBuilder: (ctx, i) => Container(),
        ),
      ],
      // ),
      // ],
    );
  }
}
