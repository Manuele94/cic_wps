import 'package:cic_wps/models/attendanceBtLocation.dart';
import 'package:cic_wps/models/calendarEvent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cic_wps/providers/attendanceBTLocations.dart';
import 'attendanceBTLocationCard.dart';

class AttendanceBTLocationsList extends StatefulWidget {
  AttendanceBTLocationsList({Key key}) : super(key: key);
  CalendarEvent _event;
  int _selectedCityIndex;
  int _selectedPlantIndex;
  AttendanceBTLocations _locationsProvider;
  List<String> _cities;
  List<String> _plants;
  Map<String, String> selectedLocation;
  bool _flagFirstPass;

  // AttendanceBTLocationsList({@required this.event});

  @override
  _AttendanceBTLocationsListState createState() =>
      _AttendanceBTLocationsListState();
}

class _AttendanceBTLocationsListState extends State<AttendanceBTLocationsList> {
  @override
  void initState() {
    widget._selectedCityIndex = -1;
    widget.selectedLocation = {"city": "", "plant": ""};
    widget._flagFirstPass = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget._event = Provider.of<CalendarEvent>(context);
    widget._locationsProvider =
        Provider.of<AttendanceBTLocations>(context, listen: false);
    _getIndexesByLocation(widget._event);

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
                itemCount: widget._cities.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == widget._selectedCityIndex) {
                    return AttendanceBTLocationCard(
                        isActive: true,
                        text: widget._cities[index],
                        onTapAction: () =>
                            _cityButtonSelection(index, widget._cities[index]));
                  } else {
                    return AttendanceBTLocationCard(
                        isActive: false,
                        text: widget._cities[index],
                        onTapAction: () =>
                            _cityButtonSelection(index, widget._cities[index]));
                  }
                }),
          ),
          Visibility(
            visible: widget._selectedCityIndex >= 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 16,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget._plants != null ? widget._plants.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == widget._selectedPlantIndex) {
                      return AttendanceBTLocationCard(
                          isActive: true,
                          text: widget._plants[index],
                          onTapAction: () => _plantButtonSelection(
                              index, widget._plants[index]));
                    } else {
                      return AttendanceBTLocationCard(
                          isActive: false,
                          text: widget._plants[index],
                          onTapAction: () => _plantButtonSelection(
                              index, widget._plants[index]));
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void _cityButtonSelection(int selectedIndex, String city) {
    setState(() {
      widget._selectedCityIndex = selectedIndex;
      widget.selectedLocation["city"] = city;
      widget._plants = widget._locationsProvider.getLocationPlantsByCity(city);
      widget._selectedPlantIndex = -1;

      // widget._event.setEventLocation(text);
    });
  }

  void _plantButtonSelection(int selectedIndex, String plant) {
    setState(() {
      widget._selectedPlantIndex = selectedIndex;
      widget.selectedLocation["plant"] = plant;
      widget._event.setEventLocation(
          widget._locationsProvider.getKeyByLocation(widget.selectedLocation));
    });
  }

  void _getIndexesByLocation(CalendarEvent event) {
    widget._cities = widget._locationsProvider.getAllLocationCities();

    if (event.getLocation.isNotEmpty && widget._flagFirstPass == false) {
      //se è un nuovo evento che non ha una location settata
      //Devo prima decodificare l'id location
      var city =
          widget._locationsProvider.getLocationCityByID(event.getLocation);
      widget._plants = widget._locationsProvider.getLocationPlantsByCity(city);
      var plant =
          widget._locationsProvider.getLocationPlantByID(event.getLocation);

      if (widget._cities != null) {
        widget._selectedCityIndex = widget._cities.indexWhere((element) {
          return element == city;
        });
      } else {
        widget._selectedCityIndex = 0;
      }

      if (widget._plants != null) {
        widget._selectedPlantIndex = widget._plants.indexWhere((element) {
          return element == plant;
        });
      } else {
        widget._selectedPlantIndex = 0;
      }
      widget._flagFirstPass = true;
    }
  }
}
