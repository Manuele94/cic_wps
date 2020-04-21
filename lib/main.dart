import 'package:flutter/material.dart';
import './screens/homePage.dart';
import './screens/profilePage.dart';
import './screens/eventDetailPage.dart';
import './models/appThemes.dart';
import './providers/calendarEvents.dart';
import 'package:cic_wps/providers/selectedCalendarEventDate.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'WorkPlaceStatus',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: HomePage(),
        routes: {
          HomePage.routeName: (ctx) => HomePage(),
          ProfilePage.routeName: (ctx) => ProfilePage(),
          EventDetailPage.routeName: (ctx) => EventDetailPage(),
        },
      ),
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CalendarEvents(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectedCalendarEventDate(),
        )
      ],
    );
  }
}
