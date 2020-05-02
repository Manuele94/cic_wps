import 'package:cic_wps/models/calendarEvent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cic_wps/providers/attendanceBTLocations.dart';
import 'attendanceBTLocationCard.dart';

class AttendanceBTLocationsList extends StatefulWidget {
  AttendanceBTLocationsList({Key key}) : super(key: key);
  // CalendarEvent _event;
  int _selectedCityIndex = -1;
  int _selectedPlantIndex = -1;
  AttendanceBTLocations _locationsProvider;
  List<String> _cities;
  List<String> _plants;
  Map<String, String> selectedLocation = {"city": "", "plant": ""};
  bool _flagFirstPass = false;

  // AttendanceBTLocationsList({@required this.event});

  @override
  _AttendanceBTLocationsListState createState() =>
      _AttendanceBTLocationsListState();
}

class _AttendanceBTLocationsListState extends State<AttendanceBTLocationsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget._locationsProvider =
        Provider.of<AttendanceBTLocations>(context, listen: false);
    var _event = Provider.of<CalendarEvent>(context);
    widget._cities = widget._locationsProvider.getAllLocationCities();

    _initPage(_event, context);
    // _getIndexesByLocation(widget._event);

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
                itemCount: widget._cities != null ? widget._cities.length : 0,
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
            visible: widget._selectedCityIndex != null
                ? widget._selectedCityIndex >= 0
                : false,
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
                          onTapAction: () => _cityButtonSelection(
                              index, widget._plants[index]));
                    } else {
                      return AttendanceBTLocationCard(
                          isActive: false,
                          text: widget._plants[index],
                          onTapAction: () => _plantButtonSelection(
                              index, widget._plants[index], _event));
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
      widget._selectedCityIndex =
          selectedIndex; //rinnovo l'indice dell'elem selez
      widget.selectedLocation["city"] = city;
      widget._plants = widget._locationsProvider.getLocationPlantsByCity(city);
      widget._selectedPlantIndex = -1;
    });
  }

  void _plantButtonSelection(
      int selectedIndex, String plant, CalendarEvent event) {
    setState(() {
      widget._selectedPlantIndex = selectedIndex;
      widget.selectedLocation["plant"] = plant;
      event.setEventLocation(
          widget._locationsProvider.getKeyByLocation(widget.selectedLocation));
    });
  }

// Tenendo conto che questa classe viene lanciata solo quando viene tappato "REMOTE WORKING"
  void _initPage(CalendarEvent event, BuildContext ctx) {
    if (event.getLocation.isEmpty) {
// Tenendo conto che io sto lavorando su una copia dell'evento controllo che anche l'evento originale sia vuoto

    } else if (event.getLocation.isNotEmpty && widget._flagFirstPass == false) {
      //Altrimenti devo decodificare l'id
      //Definisco la città dall'id
      var city =
          widget._locationsProvider.getLocationCityByID(event.getLocation);
      //Definisco tutti i plants legati alla città
      widget._plants = widget._locationsProvider.getLocationPlantsByCity(city);

      //definisco gli indici delle liste
      if (widget._cities != null && widget._selectedCityIndex == -1) {
        widget._selectedCityIndex = widget._cities.indexWhere((element) {
          return element == city;
        });
      }
      if (widget._plants != null && widget._selectedPlantIndex == -1) {
        var plant =
            widget._locationsProvider.getLocationPlantByID(event.getLocation);
        widget._selectedPlantIndex = widget._plants.indexWhere((element) {
          return element == plant;
        });
      }
      widget._flagFirstPass = true; // non deve essere rilanciato più volte
    }

    //   if (event.getLocation.isNotEmpty && widget._flagFirstPass == false) {
    //     //se è un nuovo evento che non ha una location settata
    //     //Devo prima decodificare l'id location
    //         widget._cities = widget._locationsProvider.getAllLocationCities();

    //     // var city =
    //     //     widget._locationsProvider.getLocationCityByID(event.getLocation);
    //     widget._plants = widget._locationsProvider
    //         .getLocationPlantsByCity(widget.selectedLocation["city"]);
    //     var plant =
    //         widget._locationsProvider.getLocationPlantByID(event.getLocation);

    //     if (widget._cities != null) {
    //       widget._selectedCityIndex = widget._cities.indexWhere((element) {
    //         return element == widget.selectedLocation["city"];
    //       });
    //     }

    //     if (widget._plants != null) {
    //       widget._selectedPlantIndex = widget._plants.indexWhere((element) {
    //         return element == plant;
    //       });
    //     }
    //     widget._flagFirstPass = true;
    //   }
  }
}
