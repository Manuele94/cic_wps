import 'package:cic_wps/models/calendarEvent.dart';
import 'package:cic_wps/providers/calendarEvents.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceNoteForm extends StatefulWidget {
  AttendanceNoteForm({Key key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();
  CalendarEvent _event;
  // AttendanceNoteForm({this.event});

  @override
  _AttendanceNoteFormState createState() => _AttendanceNoteFormState();
}

class _AttendanceNoteFormState extends State<AttendanceNoteForm> {
  @override
  void dispose() {
    // widget._textController.clear();
    widget._textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._event = Provider.of<CalendarEvent>(context);
    _handleText();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: Text(
            'NOTE',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Card(
                shadowColor: Theme.of(context).accentColor,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                      maxLength: 100,
                      controller: widget._textController,
                      onChanged: (String value) {
                        widget._event.setEventNote(value);
                      },
                      // initialValue: _handleText(),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline5.color),
                      decoration: InputDecoration(
                          border:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelStyle: TextStyle(color: Colors.grey),
                          hintText: 'Add Note here...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ))),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleText() {
    if (widget._event.getNote.isNotEmpty) {
      widget._textController.text = widget._event.getNote;
    } else {
      widget._textController.clear();
    }
  }
}
