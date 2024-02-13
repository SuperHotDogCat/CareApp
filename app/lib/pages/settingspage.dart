import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/utils.dart';

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
