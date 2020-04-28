import 'dart:convert';
import 'package:cic_wps/models/snackBarMessage.dart';
import 'package:cic_wps/providers/attendanceBTLocations.dart';
import 'package:cic_wps/providers/calendarEvents.dart';
import 'package:cic_wps/utilities/constants.dart';
import 'package:cic_wps/widgets/eventTable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import './profilePage.dart';
import './eventDetailPage.dart';
import '../widgets/calendar.dart';
import '../singleton/networkManager.dart';
import '../widgets/eventTable.dart';
import 'loginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  static const routeName = '/HomePage';
  static const calendarFormat = CalendarFormat.month;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future future;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    setUpNotificationPlugin();
    final _eventsProvider = Provider.of<CalendarEvents>(context, listen: false);
    final _locationsProvider =
        Provider.of<AttendanceBTLocations>(context, listen: false);
    future = _downloadInfo(_eventsProvider, _locationsProvider, context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Confirm Exit",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                      child: Text(
                        "YES",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () {
                        SystemChannels.platform
                            .invokeListMethod('SystemNavigator.pop');
                      }),
                  FlatButton(
                    child: Text(
                      "NO",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: false,
              expandedHeight: 100,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'HomePage',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline5.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(LineIcons.bell_o),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(ProfilePage.routeName),
                ),
              ],
              leading: IconButton(
                icon: Icon(LineIcons.user),
                onPressed: () =>
                    Navigator.of(context).pushNamed(ProfilePage.routeName),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Calendar(HomePage.calendarFormat),
                          EventTable(),
                        ],
                      );
                    } else {
                      return Align(
                          alignment: Alignment.center,
                          child: loaderSpinner(context));
                    }
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(EventDetailPage.routeName),
          tooltip: 'Attendance Detail',
          child: Icon(LineIcons.pencil),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.,
      ),
    );
  }

  Future<void> _downloadInfo(CalendarEvents eventProvider,
      AttendanceBTLocations locationsProvider, BuildContext ctx) async {
    String date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toString();
    try {
      var locationsResponse = await NetworkManager().getAllLocations();
      if (locationsResponse.statusCode >= 200 &&
          locationsResponse.statusCode <= 200) {
        locationsProvider
            .setEventsfromJson(json.decode(locationsResponse.body));
        var response = await NetworkManager().getAllAttendances(date);
        if (response.statusCode >= 200 || response.statusCode <= 200) {
          eventProvider.setEventsfromJson(json.decode(response.body));
        }
      }
    } catch (e) {
      SnackBarMessage.genericError(ctx, "Something went wrong!");
    }
  }

  ////////////////NOTIFICATION////////////////////
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Text('Don\'t forget to confirm this week!'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void setUpNotificationPlugin() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((ret) {
      if (!ret.didNotificationLaunchApp) {
        var initializationSettingsAndroid =
            AndroidInitializationSettings('app_icon');
        var initializationSettingsIOS = IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
        var initializationSettings = InitializationSettings(
            initializationSettingsAndroid, initializationSettingsIOS);
        flutterLocalNotificationsPlugin
            .initialize(initializationSettings,
                onSelectNotification: onSelectNotification)
            .then((init) {
          setUpNotification();
        });
      }
    });
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  }

  void setUpNotification() async {
    var time = new Time(10, 00, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'weekly-notification', 'Weekly Notification', 'Weekly Notification',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'WorkPlaceStatus',
        'Did you confirm this week?',
        Day.Friday,
        time,
        platformChannelSpecifics);
  }
}
