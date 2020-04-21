// import 'eventDate.dart';

// class EventsDates {
//   final List<EventDate> events;

//   EventsDates({this.events});

//   factory EventsDates.fromJson(Map<String, dynamic> parsedJson) {
//     var list = parsedJson['d']['results'] as List;
//     List<EventDate> eventsList =
//         list.map((i) => EventDate.fromJson(i)).toList();

//     return EventsDates(events: eventsList);
//   }

//   List<EventDate> get getEvents {
//     if (events != null) {
//       return events;
//     } else {
//       return new List<EventDate>();
//     }
//   }
// }
