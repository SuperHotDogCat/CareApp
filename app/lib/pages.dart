import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; //DateFormat
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
          SizedBox(height: 20),
          //To Do: ここにカレンダーをタップした時の予定を書く
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
            StreamBuilder<DocumentSnapshot>(
              stream: fetchUserDataSnapShots(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                // ドキュメントからデータを取得
                Map<String, dynamic> userData =
                    snapshot.data!.data() as Map<String, dynamic>;
                String name = userData['name'] ?? ''; // nameがnullの場合は空文字を表示
                String id = userData['id'] ?? ''; // idがnullの場合は空文字を表示
                return Column(
                  children: [
                    Row(children: [Text("Name: "), Text(name)]),
                    Row(children: [Text("Id: "), Text(id)]),
                  ],
                );
              },
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

  List<String> caregivers = List.generate(
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
                  itemCount: caregivers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(caregivers[index]),
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

class CalendarPageDrawer extends StatefulWidget {
  CalendarPageDrawer({super.key, required this.user});
  final User user;
  @override
  _CalendarPageDrawerState createState() => _CalendarPageDrawerState(user: user);
}

class _CalendarPageDrawerState extends State<CalendarPageDrawer> {
  _CalendarPageDrawerState({required this.user});
  final User user;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormat = DateFormat('HH:mm:ss');
  TextEditingController _scheduleController = TextEditingController();

  void _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context, 
      initialDate: _selectedDate,
      firstDate: DateTime(2000), 
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context, 
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _saveData() async {
    DateTime finalDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    String scheduleText = _scheduleController.text;
    // Firebase Firestoreにデータを保存する処理
    try {
    await FirebaseFirestore.instance.collection('users')
        .doc(user.uid)
        .collection("schedule")
        .doc(finalDateTime.toString())
        .set({"Date": finalDateTime, "schedule": scheduleText});
    // 保存後、入力フィールドをクリアする
    _scheduleController.clear();
    // 日付と時刻の選択肢をリセットするなどの処理を追加

    // ユーザーに保存が完了したことを通知する
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('予定を保存しました')),
    );
    //pop
    Navigator.pop(context);
    } catch(e) {
      
    }
  }

  @override
  Widget build(context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                '予定を追加',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            ListTile(
            title: Text('日付: ${_dateFormat.format(_selectedDate)}'),
            onTap: () => _pickDate(context),
            ),
            ListTile(
            title: Text('時刻: ${_selectedTime.format(context)}'),
            onTap: () => _pickTime(context),
            ),
            ListTile(
            title: TextField(
              controller: _scheduleController,
              decoration: InputDecoration(
                labelText: '予定の内容',
              ),
            ),
            ),
            Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveData,
              child: Text('保存'),
            ),
            ),
          ],
        ),
      );
  }
}

class MedicinePageDrawer extends StatefulWidget {
  MedicinePageDrawer({super.key});
  @override
  _MedicinePageDrawerState createState() => _MedicinePageDrawerState();
}

class _MedicinePageDrawerState extends State<MedicinePageDrawer> {
  @override
  Widget build(context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Medicine Drawer Header'),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            ListTile(
              title: Text('項目 1'),
              onTap: () {
                // Drawer内の項目がタップされたときの動作
                Navigator.pop(context); // Drawerを閉じる
              },
            ),
            ListTile(
              title: Text('項目 2'),
              onTap: () {
                // Drawer内の項目がタップされたときの動作
                Navigator.pop(context); // Drawerを閉じる
              },
            ),
          ],
        ),
      );
  }
}

class SettingsPageDrawer extends StatefulWidget {
  SettingsPageDrawer({super.key});
  @override
  _SettingsPageDrawerState createState() => _SettingsPageDrawerState();
}

class _SettingsPageDrawerState extends State<SettingsPageDrawer> {
  @override
  Widget build(context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Settings Drawer Header'),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            ListTile(
              title: Text('項目 1'),
              onTap: () {
                // Drawer内の項目がタップされたときの動作
                Navigator.pop(context); // Drawerを閉じる
              },
            ),
            ListTile(
              title: Text('項目 2'),
              onTap: () {
                // Drawer内の項目がタップされたときの動作
                Navigator.pop(context); // Drawerを閉じる
              },
            ),
          ],
        ),
      );
  }
}

class HomePageDrawer extends StatefulWidget {
  HomePageDrawer({super.key});
  @override
  _HomePageDrawerState createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  @override
  Widget build(context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Home Drawer Header'),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            ListTile(
              title: Text('項目 1'),
              onTap: () {
                // Drawer内の項目がタップされたときの動作
                Navigator.pop(context); // Drawerを閉じる
              },
            ),
            ListTile(
              title: Text('項目 2'),
              onTap: () {
                // Drawer内の項目がタップされたときの動作
                Navigator.pop(context); // Drawerを閉じる
              },
            ),
          ],
        ),
      );
  }
}