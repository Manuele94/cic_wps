import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  static const routeName = '/ProfilePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: false,
            title: const Text(
              'Profile',
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
            ),
            actions: <Widget>[],
          )
        ],
      ),
    );
  }
}
