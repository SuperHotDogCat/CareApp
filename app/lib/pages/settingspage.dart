import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class SettingsPageBody extends StatefulWidget {
  const SettingsPageBody(
      {super.key,
      required this.title,
      required this.user,
      required this.scaffoldState});
  final String title;
  final User user;
  final GlobalKey<ScaffoldState> scaffoldState;

  @override
  State<SettingsPageBody> createState() =>
      _SettingsPageState(user: user, scaffoldState: scaffoldState);
}

class _SettingsPageState extends State<SettingsPageBody> {
  _SettingsPageState({required this.user, required this.scaffoldState});
  User user;
  GlobalKey<ScaffoldState> scaffoldState;
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

  //In the future, this value will be initialized with the firebase value.
  var reminderInterval = 15;

  void remindDropDownChanged(int? value) {
    setState(() {
      reminderInterval = value!;
    });
  }

  void _openDrawer() {
    scaffoldState.currentState?.openDrawer();
  }

  List<String> careGivers = [];
  List<String> carers = [];

  Map<String, DateTime> _MealTime = {
    "breakfast": DateTime.now(),
    "lunch": DateTime.now(),
    "dinner": DateTime.now()
  };

  void _fetchMealTime() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      Map<String, DateTime> _Time = {
        "breakfast": DateTime.now(),
        "lunch": DateTime.now(),
        "dinner": DateTime.now()
      };
      var data = snapshot.data();
      // null vulnerable
      _Time["breakfast"] = data?["breakfastTime"].toDate();
      _Time["lunch"] = data?["lunchTime"].toDate();
      _Time["dinner"] = data?["dinnerTime"].toDate();
      setState(() {
        _MealTime = _Time;
      });
    });
  }

  void _fetchCaregivers() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('caregivers')
        .snapshots()
        .listen((snapshot) {
      List<String> tmpCareGivers = [];
      for (var doc in snapshot.docs) {
        tmpCareGivers.add(doc["name"]);
      }
      setState(() {
        careGivers = tmpCareGivers;
      });
    });
  }

  void _fetchCarers() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carers')
        .snapshots()
        .listen((snapshot) {
      List<String> tmpCarers = [];
      for (var doc in snapshot.docs) {
        tmpCarers.add(doc["name"]);
      }
      setState(() {
        carers = tmpCarers;
      });
    });
  }

  String _showTime(DateTime? dateTime) {
    String hour = '${dateTime?.hour}';
    String minute = '${dateTime?.minute}';
    if (hour.length == 1) {
      hour = '0' + hour;
    }
    if (minute.length == 1) {
      minute = minute + '0';
    }
    return '${hour}:${minute}';
  }

  @override
  void initState() {
    _fetchMealTime();
    _fetchCaregivers();
    _fetchCarers();
  }

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
              SizedBox(
                height: 16,
              ),
              DropdownButton(
                items: remindDropDownItems,
                onChanged: (value) => remindDropDownChanged(value),
                value: reminderInterval,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                '毎食の時間',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "朝食 " + _showTime(_MealTime["breakfast"]),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "昼食 " + _showTime(_MealTime["lunch"]),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "夜食 " + _showTime(_MealTime["dinner"]),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: _openDrawer,
                child: Text('食事時間を設定'),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                '自分の介護をしている人',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: min(careGivers.length * 50, 200),
                child: ListView.builder(
                    itemCount: careGivers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(careGivers[index]),
                        ),
                      );
                    }),
              ),
              Text(
                '自分が介護をしている人',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: min(carers.length * 50, 200),
                child: ListView.builder(
                    itemCount: carers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(carers[index]),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: _openDrawer,
                child: Text('共同介護者を追加'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
