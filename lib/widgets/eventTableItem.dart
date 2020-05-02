import 'package:cic_wps/models/calendarEvent.dart';
import 'package:cic_wps/providers/attendanceBTLocations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';

class EventTableItem extends StatelessWidget {
  final CalendarEvent event;
  void selectItem() {}

  EventTableItem({@required this.event});

  @override
  Widget build(BuildContext context) {
    final _locationsProvider =
        Provider.of<AttendanceBTLocations>(context, listen: false);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () => selectItem(),
        child: Container(
          padding: const EdgeInsets.all(17),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(event.getIconByMotivation(), color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Flexible(
                // fit: Fl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(event.getTextByMotivation(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 15),
                        overflow: TextOverflow.fade,
                        softWrap: false),
                    Text(
                        _locationsProvider
                                .getLocationCityByID(event.getLocation) +
                            " - " +
                            _locationsProvider
                                .getLocationPlantByID(event.getLocation),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 13),
                        overflow: TextOverflow.fade,
                        softWrap: false),
                    Text(event.getNote,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                        overflow: TextOverflow.fade,
                        softWrap: false),
                  ],
                ),
              ),
              // Spacer(),
              Icon(LineIcons.ellipsis_v, color: Colors.white),
            ],
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                event.getColorByMotivation(),
                event.getColorByMotivation().withOpacity(0.5)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // List<Color> _randomColor() {
  //   final baseColors = [
  //     Colors.blueAccent,
  //     Colors.redAccent,
  //     Colors.deepPurpleAccent,
  //     Colors.deepOrangeAccent,
  //     Colors.indigoAccent,
  //   ];

  //   final randomIndex = Random().nextInt(baseColors.length);
  //   return [baseColors[randomIndex], baseColors[randomIndex].withOpacity(0.7)];
  // }

  // List<Color> _randomColor(BuildContext ctx, CalendarEvent event) {
  //   // final baseColors = [Theme.of(ctx).primaryColor, Theme.of(ctx).accentColor];
  //   // final baseColors = event.getColorByMotivation();

  //   // // final randomIndex = Random().nextInt(baseColors.length);
  //   // return [baseColors[randomIndex], baseColors[randomIndex].withOpacity(0.5)];
  // }

}
