import 'package:cic_wps/providers/attendanceBTLocations.dart';
import 'package:cic_wps/providers/attendanceBtLocation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationChangeHitsList extends StatefulWidget {
  // LocationChangeHitsList({Key key}) : super(key: key);

  // AttendanceBTLocations _locationsProvider;
  bool customerButtonSelected;
  bool ibmButtonSelected;
  // String selectedLocation;
  int _selectedIndex;

  LocationChangeHitsList({
    required this.customerButtonSelected,
    required this.ibmButtonSelected,
    // @required this.selectedLocation,
  });

  @override
  _LocationChangeHitsListState createState() => _LocationChangeHitsListState();
}

class _LocationChangeHitsListState extends State<LocationChangeHitsList> {
  @override
  Widget build(BuildContext context) {
    final _locationsProvider =
        Provider.of<AttendanceBTLocations>(context, listen: false);
    final _customerLocation = _locationsProvider.getAllCustomerLocationsInfo();
    final _ibmLocation = _locationsProvider.getAllIBMLocationsInfo();

    return Expanded(
      child: ListView.builder(
        itemCount: _getCount(_customerLocation, _ibmLocation),
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                selected: index == widget._selectedIndex ? true : false,
                onTap: () => _selectElement(
                    _customerLocation, _ibmLocation, index, _locationsProvider),
                title: Text(
                  _getText(_customerLocation, _ibmLocation, index),
                  style: TextStyle(color: _getTextColor(context, index)),
                ),
                // focusColor: Theme.of(context).accentColor,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Divider(
                  thickness: 0.5,
                  color: Theme.of(context).textTheme.headline5.color,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int _getCount(List customerLocations, List ibmLocations) {
    if (widget.customerButtonSelected) {
      return customerLocations.length;
    } else if (widget.ibmButtonSelected) {
      return ibmLocations.length;
    } else {
      return 0;
    }
  }

  String _getText(List customerLocations, List ibmLocations, int index) {
    List app;
    if (widget.customerButtonSelected) {
      app = customerLocations[index];
    } else if (widget.ibmButtonSelected) {
      app = ibmLocations[index];
    }
    return app.first + " - " + app.last;
  }

  Color _getTextColor(BuildContext ctx, int index) {
    Color color = Theme.of(ctx).textTheme.headline5.color;
    if (widget._selectedIndex == index) {
      color = Theme.of(ctx).accentColor;
    }
    return color;
  }

  void _selectElement(List customerLocations, List ibmLocations, int index,
      AttendanceBTLocations provider) {
    List app;

    if (widget.customerButtonSelected) {
      app = customerLocations[index];
    } else if (widget.ibmButtonSelected) {
      app = ibmLocations[index];
    }
    Map<String, String> location = {"city": app.first, "plant": app.last};

    setState(() {
      final singlLocProvider =
          Provider.of<AttendanceBtLocation>(context, listen: false);
      singlLocProvider.setIdLocation(provider.getKeyByLocation(location));

      widget._selectedIndex = index;
    });
  }
}
