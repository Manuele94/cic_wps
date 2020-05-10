import 'package:cic_wps/screens/locationChangePage.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  static const routeName = '/ProfilePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.headline5.color),
          textAlign: TextAlign.start,
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading:
                Icon(LineIcons.home, color: Theme.of(context).iconTheme.color),
            title: Text(
              "Change your Work Place",
              style:
                  TextStyle(color: Theme.of(context).textTheme.headline5.color),
              textAlign: TextAlign.justify,
            ),
            onTap: () =>
                Navigator.of(context).pushNamed(LocationChangePage.routeName),
          ),
        ],
      ),
    );
  }
}
