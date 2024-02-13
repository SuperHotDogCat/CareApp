import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPageBody extends StatefulWidget {
  const CalendarPageBody({super.key, required this.title, required this.user});
  final title;
  final User user;
  @override
  State<CalendarPageBody> createState() => _CalendarPageState(user: user);
}

class _CalendarPageState extends State<CalendarPageBody> {
  _CalendarPageState({required this.user});
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  User user;

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
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selected, day);
            },
          ),
          SizedBox(height: 20),
          //To Do: ここにカレンダーをタップした時の予定を書く
        ],
      ),
    );
  }
}