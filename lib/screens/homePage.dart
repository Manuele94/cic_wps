import 'package:cic_wps/widgets/eventTable.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import './profilePage.dart';
import './eventDetailPage.dart';
import '../widgets/calendar.dart';
import '../widgets/eventTable.dart';

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
            expandedHeight: 70,
            title: Text(
              'HomePage',
              style: TextStyle(
                color: Theme.of(context).textTheme.headline5.color,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(LineIcons.user),
                onPressed: () =>
                    Navigator.of(context).pushNamed(ProfilePage.routeName),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Calendar(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Selected Events',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline5.color,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                EventTable(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(EventDetailPage.routeName),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
