import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; //DateFormat

class CalendarPageDrawer extends StatefulWidget {
  const CalendarPageDrawer({super.key, required this.user});
  final User user;
  @override
  CalendarPageDrawerState createState() => CalendarPageDrawerState();
}

class CalendarPageDrawerState extends State<CalendarPageDrawer> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _selectedColorIndex = 0;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final TextEditingController _scheduleController = TextEditingController();
  final List<String> colorCodes = [
    '0xFFCE93D8',
    '0xFFFF8A65',
    '0xFFF44336'
  ]; // 通常時, 少し重要, 超重要

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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection("schedule")
        .doc(finalDateTime.toString())
        .set({
      "Date": finalDateTime,
      "schedule": scheduleText,
      "color": colorCodes[_selectedColorIndex]
    }).then((value) {
      // 保存後、入力フィールドをクリアする
      try {
        _scheduleController.clear();
        // ユーザーに保存が完了したことを通知する
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('予定を保存しました')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('予定の追加に失敗しました')),
        );
      }
    });
  }

  @override
  Widget build(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: const Text(
              '予定を追加',
              style: TextStyle(
                fontSize: 24,
              ),
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
              decoration: const InputDecoration(
                labelText: '予定の内容',
              ),
            ),
          ),
          const ListTile(
            title: Text('予定の重要度'),
          ),
          // 色選択のためのRadioListTileを追加
          RadioListTile<int>(
            title: Text(
              '普通',
              style: TextStyle(color: Color(int.parse(colorCodes[0]))),
            ),
            value: 0,
            groupValue: _selectedColorIndex,
            onChanged: (int? value) {
              setState(() {
                _selectedColorIndex = value!;
              });
            },
          ),
          RadioListTile<int>(
            title: Text(
              'やや重要',
              style: TextStyle(color: Color(int.parse(colorCodes[1]))),
            ),
            value: 1,
            groupValue: _selectedColorIndex,
            onChanged: (int? value) {
              setState(() {
                _selectedColorIndex = value!;
              });
            },
          ),
          RadioListTile<int>(
            title: Text(
              '超重要',
              style: TextStyle(color: Color(int.parse(colorCodes[2]))),
            ),
            value: 2,
            groupValue: _selectedColorIndex,
            onChanged: (int? value) {
              setState(() {
                _selectedColorIndex = value!;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveData,
              child: const Text('保存'),
            ),
          ),
        ],
      ),
    );
  }
}
