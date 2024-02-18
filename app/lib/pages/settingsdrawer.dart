import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPageDrawer extends StatefulWidget {
  SettingsPageDrawer({super.key, required this.user});
  final User user;
  @override
  SettingsPageDrawerState createState() =>
      SettingsPageDrawerState();
}

class SettingsPageDrawerState extends State<SettingsPageDrawer> {
  final TextEditingController _caregiverController = TextEditingController();

  // DateTime型で変数を初期化、ローカルタイムで朝8時に設定
  DateTime _breakfastTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 0);
  DateTime _lunchTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0);
  DateTime _dinnerTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 0);

  void _addCareGiver() async {
    String addCareGiverId = _caregiverController.text;
    final collection = FirebaseFirestore.instance.collection('users');
    final querySnapshot =
        await collection.where('id', isEqualTo: addCareGiverId).get();
    //add caregivers
    DocumentReference caregivers =
        await FirebaseFirestore.instance.collection('users').doc(widget.user.uid);

    DocumentSnapshot selfSnapShot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();
    String? selfName;
    if (selfSnapShot.exists) {
      Map<String, dynamic> userSelfData =
          selfSnapShot.data() as Map<String, dynamic>;
      selfName = userSelfData["name"];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('データが存在しません')),
      );
    }

    for (var doc in querySnapshot.docs) {
      var data = doc.data();
      if (widget.user.uid != data["id"] && selfName != null) {
        caregivers
            .collection('caregivers')
            .doc(addCareGiverId)
            .set({"id": data["id"], "name": data["name"]});
        //add carers
        CollectionReference carers = await FirebaseFirestore.instance
            .collection('users')
            .doc(data["id"])
            .collection("carers");
        carers.doc(widget.user.uid).set({"id": widget.user.uid, "name": selfName});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('介護者を登録しました')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('介護者のIDは自分のIDと同じでないことを確認してください')),
        );
      }
    }
    Navigator.pop(context);
  }

  Future<void> _showTimePicker(String mealType, DateTime mealTime,
      Function(DateTime) updateFunction) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(mealTime),
    );

    if (pickedTime != null) {
      final newTime = DateTime(mealTime.year, mealTime.month, mealTime.day,
          pickedTime.hour, pickedTime.minute);
      setState(() {
        updateFunction(newTime);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登録が成功しました')),
        );
      });
      //Add data
      DocumentReference userData =
          await FirebaseFirestore.instance.collection('users').doc(widget.user.uid);
      userData.set({mealType: newTime}, SetOptions(merge: true)); //add Data
    }
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
              '設定',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                _showTimePicker("breakfastTime", _breakfastTime, (newTime) {
              _breakfastTime = newTime;
            }),
            child: const Text('朝食の時間を設定'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                _showTimePicker("lunchTime", _lunchTime, (newTime) {
              _lunchTime = newTime;
            }),
            child: const Text('昼食の時間を設定'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                _showTimePicker("dinnerTime", _dinnerTime, (newTime) {
              _dinnerTime = newTime;
            }),
            child: const Text('夜食の時間を設定'),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: TextField(
              controller: _caregiverController,
              decoration: const InputDecoration(
                labelText: '介護者のID',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addCareGiver,
              child: const Text('追加'),
            ),
          ),
        ],
      ),
    );
  }
}
