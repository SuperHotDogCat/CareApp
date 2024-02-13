import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageDrawer extends StatefulWidget {
  HomePageDrawer({super.key, required this.user});
  final User user;
  @override
  _HomePageDrawerState createState() => _HomePageDrawerState(user: user);
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  _HomePageDrawerState({required this.user});
  final User user;
  TextEditingController _caregiverController = TextEditingController();

  void _addCareGiver() async {
    String addCareGiverId = _caregiverController.text;
    final collection = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await collection.where('id', isEqualTo: addCareGiverId).get();
    CollectionReference caregivers = await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('caregivers');

    for (var doc in querySnapshot.docs) {
      var data = doc.data();
      if (user.uid != data["id"]){
        caregivers.doc(addCareGiverId).set({"id": data["id"], "name": data["name"]});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('介護者のIDは自分のIDと同じでないことを確認してください')),
        );
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                '共同介護者の追加',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            ListTile(
            title: TextField(
              controller: _caregiverController,
              decoration: InputDecoration(
                labelText: '介護者のID',
              ),
              ),
            ),
            Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addCareGiver,
              child: Text('追加'),
            ),
            ),
          ],
        ),
      );
  }
}