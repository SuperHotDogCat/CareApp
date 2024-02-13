import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; //DateFormat

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