import 'package:cic_wps/providers/attendanceBTLocations.dart';
import 'package:flutter/material.dart';

class AttendanceBTLocationCard extends StatefulWidget {
  final bool isActive;
  final String text;
  final Function onTapAction;
  // AttendanceBTLocationItem({Key key}) : super(key: key);
  AttendanceBTLocationCard(
      {@required this.isActive,
      @required this.text,
      @required this.onTapAction});

  @override
  _AttendanceBTLocationCardState createState() =>
      _AttendanceBTLocationCardState();
}

class _AttendanceBTLocationCardState extends State<AttendanceBTLocationCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTapAction,
      splashColor: Theme.of(context).accentColor,
      child: Card(
        color: _defineColorOfSelectedCardByEvent(context),
        shadowColor: Theme.of(context).accentColor,
        elevation: 2,
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _defineColorOfSelectedTextByEvent(context),
                    fontSize: 18),
              ),
            )),
      ),
    );
  }

  //SI DEFINISCE IL COLORE DELLA CARD SELEZIONATA
  Color _defineColorOfSelectedCardByEvent(BuildContext context) {
    if (widget.isActive == true) {
      return Theme.of(context).accentColor;
    }
  }

  //SI DEFINISCE IL COLORE DEL TESTO DELLA CARD SELEZIONATA
  Color _defineColorOfSelectedTextByEvent(BuildContext context) {
    if (widget.isActive == true) {
      return Colors.white;
    } else {
      return Theme.of(context).textTheme.headline5.color;
    }
  }
}
