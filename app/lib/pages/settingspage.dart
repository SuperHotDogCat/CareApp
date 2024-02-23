import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

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
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPageBody> {
  final remindDropDownItems = const [
    DropdownMenuItem(
      value: 15,
      child: Text("15 分"),
    ),
    DropdownMenuItem(
      value: 30,
      child: Text("30 分"),
    ),
    DropdownMenuItem(
      value: 45,
      child: Text("45 分"),
    ),
    DropdownMenuItem(
      value: 60,
      child: Text("60 分"),
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
    widget.scaffoldState.currentState?.openDrawer();
  }

  List<String> careGivers = [];
  List<String> careRecipients = [];

  Map<String, DateTime> _mealTime = {
    "breakfast": DateTime.now(),
    "lunch": DateTime.now(),
    "dinner": DateTime.now()
  };

  void _fetchMealTime() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .snapshots()
        .listen((snapshot) {
      Map<String, DateTime> time = {
        "breakfast": DateTime.now(),
        "lunch": DateTime.now(),
        "dinner": DateTime.now()
      };
      var data = snapshot.data();
      // null vulnerable
      time["breakfast"] = data?["breakfastTime"].toDate();
      time["lunch"] = data?["lunchTime"].toDate();
      time["dinner"] = data?["dinnerTime"].toDate();
      setState(() {
        _mealTime = time;
      });
    });
  }

  void _fetchCaregivers() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
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

  void _fetchCareRecipients() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('carerecipients')
        .snapshots()
        .listen((snapshot) {
      List<String> tmpCareRecipients = [];
      for (var doc in snapshot.docs) {
        tmpCareRecipients.add(doc["name"]);
      }
      setState(() {
        careRecipients = tmpCareRecipients;
      });
    });
  }

  String _showTime(DateTime? dateTime) {
    String hour = '${dateTime?.hour}';
    String minute = '${dateTime?.minute}';
    if (hour.length == 1) {
      hour = '0$hour';
    }
    if (minute.length == 1) {
      minute = '${minute}0';
    }
    return '$hour:$minute';
  }

  @override
  void initState() {
    super.initState();
    _fetchMealTime();
    _fetchCaregivers();
    _fetchCareRecipients();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                '通知の頻度',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownButton(
                items: remindDropDownItems,
                onChanged: (value) => remindDropDownChanged(value),
                value: reminderInterval,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '毎食の時間',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '朝食 ${_showTime(_mealTime["breakfast"])}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '昼食 ${_showTime(_mealTime["lunch"])}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '夜食 ${_showTime(_mealTime["dinner"])}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: _openDrawer,
                child: const Text('食事時間を設定'),
              ),
              const SizedBox(
                height: 16,
              ),
              if (careGivers.isNotEmpty)
                Text(
                  '自分の介護をしている人',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              const SizedBox(
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
              if (careRecipients.isNotEmpty)
                Text(
                  '自分が介護をしている人',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: min(careRecipients.length * 50, 200),
                child: ListView.builder(
                    itemCount: careRecipients.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(careRecipients[index]),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: _openDrawer,
                child: const Text('介護者を追加'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
