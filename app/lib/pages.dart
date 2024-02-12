import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math';
import 'utils.dart';

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
        ],
      ),
    );
  }
}

class MedicinePageBody extends StatefulWidget {
  const MedicinePageBody({super.key, required this.title, required this.user});
  final String title;
  final User user;

  @override
  State<MedicinePageBody> createState() => _MedicinePageState(user: user);
}

class _MedicinePageState extends State<MedicinePageBody> {
  _MedicinePageState({required this.user});
  // 薬リストのデータ
  List<String> medicineList = ["コンサータ"];
  List<String> imagesList = ["assets/1179009G1022_000.jpg"];
  User user;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
      itemCount: medicineList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Image.asset(imagesList[index]),
            title: Text(medicineList[index]),
          ),
        );
      },
    ));
  }
}

class SettingsPageBody extends StatefulWidget {
  const SettingsPageBody({super.key, required this.title, required this.user});
  final String title;
  final User user;

  @override
  State<SettingsPageBody> createState() => _SettingsPageState(user: user);
}

class _SettingsPageState extends State<SettingsPageBody> {
  _SettingsPageState({required this.user});
  // 薬リストのデータ
  List<String> medicineList = ["hogehoge"];
  List<String> imagesList = ["assets/1179009G1022_000.jpg"];
  User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [Text("Name: "), Text("Hoge Tarou")],
            ),
            Row(
              children: [Text("ID: "), Text("Yaa")],
            ),
          ],
        ),
      ),
    );
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key, required this.title, required this.user});
  final String title;
  final User user;

  @override
  State<HomePageBody> createState() => _HomePageState(user: user);
}

class _HomePageState extends State<HomePageBody> {
  _HomePageState({required this.user});
  User user;
  final remindDropDownItems = [
    DropdownMenuItem(
      child: Text("15 min"),
      value: 15,
    ),
    DropdownMenuItem(
      child: Text("30 min"),
      value: 30,
    ),
    DropdownMenuItem(
      child: Text("45 min"),
      value: 45,
    ),
    DropdownMenuItem(
      child: Text("60 min"),
      value: 60,
    ),
  ];

  var isSelectedValue = 15;

  void remindDropDownChanged(int? value) {
    setState(() {
      isSelectedValue = value!;
    });
  }

  List<String> carers = List.generate(
      10,
      (_) => String.fromCharCodes(
          List.generate(5, (_) => Random().nextInt(26) + 97)));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                '通知の頻度',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              DropdownButton(
                items: remindDropDownItems,
                onChanged: (value) => remindDropDownChanged(value),
                value: isSelectedValue,
              ),
              Text(
                '共同介護者',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: carers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(carers[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
