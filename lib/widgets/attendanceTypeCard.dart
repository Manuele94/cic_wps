import 'package:flutter/material.dart';

class AttendanceTypeCard extends StatefulWidget {
  final bool isActive;
  final IconData icon;
  final String text;
  final Function onTapAction;

  AttendanceTypeCard(
      {required this.isActive,
      required this.icon,
      required this.text,
      required this.onTapAction});
  // AttendanceType({@required this.buttonTypeEvent, @required this.event});

  @override
  _AttendanceTypeCardState createState() => _AttendanceTypeCardState();
}

class _AttendanceTypeCardState extends State<AttendanceTypeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: widget.onTapAction,
            splashColor: Theme.of(context).accentColor,
            child: Card(
              color: _defineColorOfSelectedCardByEvent(context),
              shadowColor: Theme.of(context).accentColor,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(widget.icon,
                    color: _defineColorOfSelectedIconByEvent(context)),
              ),
            ),
          ),
          Text(
            widget.text,
          ),
        ],
      ),
    );
  }

  //SI DEFINISCE IL COLORE DELLA CARD SELEZIONATA
  Color _defineColorOfSelectedCardByEvent(BuildContext context) {
    if (widget.isActive == true) {
      return Theme.of(context).accentColor;
    }
  }

  //SI DEFINISCE IL COLORE DEL ICONA DELLA CARD SELEZIONATA
  Color _defineColorOfSelectedIconByEvent(BuildContext context) {
    if (widget.isActive == true) {
      return Colors.white;
    } else {
      return Theme.of(context).iconTheme.color;
    }
  }
}
