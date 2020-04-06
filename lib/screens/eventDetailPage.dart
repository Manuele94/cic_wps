import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:line_icons/line_icons.dart';
import '../widgets/calendar.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({Key key}) : super(key: key);

  static const routeName = '/EventDetailPage';
  static const calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: false,
            expandedHeight: 70,
            title: Text(
              'EventDetail',
              style: TextStyle(
                color: Theme.of(context).textTheme.headline5.color,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Calendar(calendarFormat),
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
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () =>
      //       Navigator.of(context).pushNamed(EventDetailPage.routeName),
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
