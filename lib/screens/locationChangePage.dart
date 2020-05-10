import 'dart:convert';

import 'package:cic_wps/models/sapReturnMessage.dart';
import 'package:cic_wps/models/snackBarMessage.dart';
import 'package:cic_wps/providers/attendanceBTLocations.dart';
import 'package:cic_wps/providers/attendanceBtLocation.dart';
import 'package:cic_wps/screens/homePage.dart';
import 'package:cic_wps/singleton/dbManager.dart';
import 'package:cic_wps/singleton/networkManager.dart';
import 'package:cic_wps/utilities/constants.dart';
import 'package:cic_wps/utilities/sapMessageType.dart';
import 'package:cic_wps/widgets/locationChangeHitsList.dart';
import 'package:cic_wps/widgets/locationChangeTypeList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationChangePage extends StatefulWidget {
  LocationChangePage({Key key}) : super(key: key);
  static const routeName = '/LocationChangePage';

  @override
  _LocationChangePageState createState() => _LocationChangePageState();
}

class _LocationChangePageState extends State<LocationChangePage> {
  bool _customerButtonisActive = false;
  bool _ibmButtonSelectedisActive = false;

  @override
  Widget build(BuildContext context) {
    final location =
        AttendanceBtLocation(idLocation: "", city: "", plant: "", customer: "");
    return ChangeNotifierProvider.value(
      value: location,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          title: Text(
            'Your Work Place',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.headline5.color),
            textAlign: TextAlign.start,
          ),
          actions: [
            Consumer<AttendanceBtLocation>(
              builder: (_, location, __) => Visibility(
                visible: location.getIdLocation.isNotEmpty,
                child: FlatButton(
                  onPressed: () => _finishButtonPressed(location, context),
                  child: Text(
                    "Finish",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Where you will stay for the next days?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(height: 20),
              LocationChangeTypeList(
                  customerButtonSelected: _customerButtonisActive,
                  customerButtonSelectedAction: _customerButtonTapped,
                  ibmButtonSelected: _ibmButtonSelectedisActive,
                  ibmButtonSelectedAction: _ibmButtonTapped),
              Visibility(
                  visible: _visibilityCondition(),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Where is located?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(height: 20),
                        LocationChangeHitsList(
                          customerButtonSelected: _customerButtonisActive,
                          ibmButtonSelected: _ibmButtonSelectedisActive,
                          // selectedLocation: _selectedLocation,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  bool _visibilityCondition() {
    if (!_customerButtonisActive && !_ibmButtonSelectedisActive) {
      return false;
    }
    return true;
  }

  void _customerButtonTapped() {
    setState(() {
      if (!_customerButtonisActive) {
        _customerButtonisActive = true;
        _ibmButtonSelectedisActive = false;
      }
    });
  }

  void _ibmButtonTapped() {
    setState(() {
      if (!_ibmButtonSelectedisActive) {
        _ibmButtonSelectedisActive = true;
        _customerButtonisActive = false;
      }
    });
  }

  Future<void> _finishButtonPressed(
      AttendanceBtLocation location, BuildContext ctx) async {
    final locationsProvider =
        Provider.of<AttendanceBTLocations>(context, listen: false);
    final convLoc = locationsProvider
        .getFormattedLocationAllInfoByID(location.getIdLocation);

    startLoadingSpinner(ctx);

    try {
      var response = await NetworkManager().postLocationOfBelonging(location);
      var message = SapReturnMessage.fromJson(jsonDecode(response.body));
      if (message.getCode == SapMessageType.E.value ||
          message.getCode == SapMessageType.W.value) {
        Navigator.pop(ctx);

        return message.returnSnackByMessage(ctx);
      } else {
        await DbManager().modifyUserLocation("user", convLoc);
        Navigator.pop(ctx);
        // Navigator.pop(ctx);
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);

        return message.returnSnackByMessage(ctx);
      }
    } catch (e) {
      Navigator.pop(ctx);
      SnackBarMessage.genericError(ctx, "Something went wrong!");
    }
  }
}
