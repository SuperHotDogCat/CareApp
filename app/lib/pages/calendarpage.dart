import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPageBody extends StatefulWidget {
  const CalendarPageBody({super.key, required this.title, required this.user});
  final String title;
  final User user;
  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPageBody> {
  DateTime _focused = DateTime.now();
  DateTime _selected = DateTime.now();

  Map<DateTime, List<dynamic>> _events = {};
  Map<DateTime, List<DateTime>> _detailedTime = {};
  List<dynamic> _selectedEvents = [];
  List<DateTime> _selectedDetailedTime = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _selectedEvents =
        _events[DateTime(_selected.year, _selected.month, _selected.day)] ?? [];
    _selectedDetailedTime = _detailedTime[
            DateTime(_selected.year, _selected.month, _selected.day)] ??
        [];
  }

  void _fetchEvents() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('schedule')
        .snapshots()
        .listen((snapshot) {
      final Map<DateTime, List<dynamic>> fetchedEvents = {};
      final Map<DateTime, List<DateTime>> fetchedTime = {};
      for (var doc in snapshot.docs) {
        var data = doc.data();
        final date = data["Date"]
            .toDate(); //For now, this app can only be used in Japan.
        final schedule = data["schedule"];
        final dateKey =
            DateTime(date.year, date.month, date.day); //To show the calendar
        if (fetchedEvents[dateKey] == null) {
          fetchedEvents[dateKey] = [schedule];
          fetchedTime[dateKey] = [date];
        } else {
          fetchedEvents[dateKey]?.add(schedule);
          fetchedTime[dateKey]?.add(date);
        }
      }

      setState(() {
        _events = fetchedEvents;
        _detailedTime = fetchedTime;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TableCalendar(
            focusedDay: _focused,
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            onDaySelected: (selected, focused) {
              if (!isSameDay(_selected, selected)) {
                setState(() {
                  _selected = selected;
                  _focused = focused;
                  _selectedEvents = _events[DateTime(
                          _selected.year, _selected.month, _selected.day)] ??
                      [];
                  _selectedDetailedTime = _detailedTime[DateTime(
                          _selected.year, _selected.month, _selected.day)] ??
                      [];
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selected, day);
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarBuilders:
                CalendarBuilders(defaultBuilder: (context, date, _) {
              var datelocal = DateTime(date.year, date.month, date.day);
              if (_events.containsKey(datelocal)) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    width: 100,
                    height: 100,
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              } else {
                return null;
              }
            }),
          ),
          const SizedBox(height: 20),
          //To Do: ここにカレンダーをタップした時の予定を書く
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                if (_selectedEvents[index] != "") {
                  var hourMinute =
                      '${_selectedDetailedTime[index].hour.toString()}:${_selectedDetailedTime[index].minute.toString()}';
                  var content = '$hourMinute ${_selectedEvents[index]}';
                  return Card(
                      child: ListTile(
                    title: Text(content),
                  ));
                } else {
                  return null;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
