import 'package:flutter/material.dart';
import './screens/homePage.dart';
import './screens/profilePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkPlaceStatus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
        fontFamily: 'Raleway',
        appBarTheme: AppBarTheme(
            color: Colors.transparent,
            iconTheme: (IconThemeData(color: Colors.black87))),
      ),
      home: HomePage(),
      routes: {
        HomePage.routeName: (ctx) => HomePage(),
        ProfilePage.routeName: (ctx) => ProfilePage(),
      },
    );
  }
}