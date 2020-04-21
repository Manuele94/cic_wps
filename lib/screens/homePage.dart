import 'dart:convert';

import 'package:cic_wps/providers/calendarEvents.dart';
import 'package:cic_wps/providers/selectedCalendarEventDate.dart';
import 'package:cic_wps/singleton/dbManager.dart';
import 'package:cic_wps/utilities/constants.dart';
import 'package:cic_wps/widgets/eventTable.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import './profilePage.dart';
import './eventDetailPage.dart';
import '../widgets/calendar.dart';
import '../singleton/networkManager.dart';
import '../widgets/eventTable.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  static const routeName = '/HomePage';
  static const calendarFormat = CalendarFormat.month;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future future;

  @override
  void initState() {
    super.initState();

    final eventsProvider = Provider.of<CalendarEvents>(context, listen: false);
    future = _httpCall(eventsProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return loaderSpinner;
                      break;
                    case ConnectionState.waiting:
                      return loaderSpinner;
                      break;
                    case ConnectionState.done:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Calendar(HomePage.calendarFormat),
                          EventTable(),
                        ],
                      );
                      break;
                    case ConnectionState.active:
                      return Text("active");
                      break;
                    default:
                      return Text("default");
                  }
                }
                // child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // children: <Widget>[
                // Calendar(calendarFormat),
                // EventTable(),
                // ],
                // ),
                ),
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
    );
  }

  Future<void> _httpCall(CalendarEvents eventProvider) async {
    await DbManager.insert('user',
        {'id': 0, 'username': "IT065216", 'sUser': "", 'password': "prova"});
    String date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toString();
    var response = await NetworkManager().getAllAttendances(date);
    eventProvider.setEventsfromJson(json.decode(response.body));
  }
}
