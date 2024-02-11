import 'package:flutter/material.dart';
import 'dart:math';

import 'package:table_calendar/table_calendar.dart';

class CalendarPageBody extends StatefulWidget {
  const CalendarPageBody({super.key, required this.title});
  final title;
  @override
  State<CalendarPageBody> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPageBody> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

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
  const MedicinePageBody({super.key, required this.title});
  final String title;

  @override
  State<MedicinePageBody> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePageBody> {
  // 薬リストのデータ
  List<String> medicineList = ["コンサータ"];
  List<String> imagesList = ["assets/1179009G1022_000.jpg"];

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
  const SettingsPageBody({super.key, required this.title});
  final String title;

  @override
  State<SettingsPageBody> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPageBody> {
  // 薬リストのデータ
  List<String> medicineList = ["hogehoge"];
  List<String> imagesList = ["assets/1179009G1022_000.jpg"];
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
  const HomePageBody({super.key, required this.title});
  final String title;

  @override
  State<HomePageBody> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageBody> {
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
