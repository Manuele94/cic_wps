import 'package:flutter/material.dart';

class LocationChangeTypeList extends StatefulWidget {
  // LocationChangeTypeList({Key key}) : super(key: key);

  bool customerButtonSelected;
  Function customerButtonSelectedAction;
  bool ibmButtonSelected;
  Function ibmButtonSelectedAction;

  LocationChangeTypeList({
    @required this.customerButtonSelected,
    @required this.customerButtonSelectedAction,
    @required this.ibmButtonSelected,
    @required this.ibmButtonSelectedAction,
  });

  @override
  _LocationChangeTypeListState createState() => _LocationChangeTypeListState();
}

class _LocationChangeTypeListState extends State<LocationChangeTypeList> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: <Widget>[
      ListTile(
          title: Text(
            "Client site",
            style: TextStyle(
              color: widget.customerButtonSelected
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textTheme.headline5.color,
            ),
          ),
          selected: widget.customerButtonSelected,
          onTap: widget.customerButtonSelectedAction),
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Divider(
          thickness: 0.5,
          color: Theme.of(context).textTheme.headline5.color,
        ),
      ),
      ListTile(

          // focusColor: Theme.of(context).accentColor,
          title: Text(
            "IBM site",
            style: TextStyle(
              color: widget.ibmButtonSelected
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textTheme.headline5.color,
            ),
          ),
          selected: widget.ibmButtonSelected,
          onTap: widget.ibmButtonSelectedAction),
    ]);
  }

  // void _typeButtonTapped() {
  //   setState(() {
  //     if (widget.customerButtonSelected) {
  //       widget.customerButtonSelected = false;
  //     } else if (widget.ibmButtonSelected) {
  //       widget.ibmButtonSelected = false;
  //     } else if (!widget.customerButtonSelected) {
  //       widget.customerButtonSelected = true;
  //       widget.ibmButtonSelected = false;
  //     } else if (!widget.ibmButtonSelected) {
  //       widget.ibmButtonSelected = true;
  //       widget.customerButtonSelected = false;
  //     }
  //   });
  // }

}
