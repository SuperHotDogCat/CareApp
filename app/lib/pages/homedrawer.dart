import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageDrawer extends StatefulWidget {
  const HomePageDrawer({super.key, required this.user});
  final User user;
  @override
  HomePageDrawerState createState() => HomePageDrawerState();
}

class HomePageDrawerState extends State<HomePageDrawer> {
  final TextEditingController _everyDayTaskController = TextEditingController();
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
            child: const Text('日常的なタスクを追加'),
          ),
          ListTile(
            title: TextField(
              controller: _everyDayTaskController,
              decoration: const InputDecoration(
                labelText: '日常的なタスクの追加',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addEveryDayTask,
              child: const Text('追加'),
            ),
          ),
        ],
      ),
    );
  }

  void _addEveryDayTask() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('everydaytask')
        .doc(_everyDayTaskController.text)
        .set({"task": _everyDayTaskController.text},
            SetOptions(merge: true)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('日常的なタスクを登録しました')),
      );
      Navigator.pop(context);
    });
  }
}
