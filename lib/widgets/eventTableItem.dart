import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EventTableItem extends StatelessWidget {
  final String eventType;
  final String location;
  final String description;
  void selectItem() {}

  EventTableItem(
      {@required this.eventType,
      @required this.location,
      @required this.description});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectItem(),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              eventType,
              textAlign: TextAlign.left,
            ),
            Text(
              location,
              textAlign: TextAlign.left,
            ),
            Text(
              description,
              textAlign: TextAlign.left,
            ),
          ],
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
