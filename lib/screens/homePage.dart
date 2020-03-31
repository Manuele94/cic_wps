import 'package:flutter/material.dart';
import './profilePage.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  static const routeName = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: false,
            title: const Text(
              'HomePage',
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(LineIcons.user),
                onPressed: () =>
                    Navigator.of(context).pushNamed(ProfilePage.routeName),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
