import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/utils.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key, required this.title, required this.user});
  final String title;
  final User user;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePageBody> {
  List<String> everyDayTask = [];
  List<bool> everyDayTaskAchieved = [];

  @override
  void initState() {
    super.initState();
    _fetchEveryDayTask();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // StreamBuilderを含むコード...
            StreamBuilder<DocumentSnapshot>(
              stream: fetchUserDataSnapShots(
                  widget.user), // この関数はユーザーのデータをフェッチします（仮の関数）
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // ドキュメントからデータを取得
                Map<String, dynamic> userData =
                    snapshot.data?.data() as Map<String, dynamic>? ?? {};
                String name = userData['name'] ?? ''; // nameがnullの場合は空文字を表示
                String id = userData['id'] ?? ''; // idがnullの場合は空文字を表示
                return Card(
                  elevation: 4, // カードの影
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 角の丸み
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "名前 ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                name,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10), // 少し間隔を空ける
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "ID: ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                id,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Checkboxを追加
            const SizedBox(height: 20),
            if (everyDayTask.isNotEmpty)
              const Text(
                '日常のタスク',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            Column(
              children: List.generate(everyDayTask.length, (index) {
                return ListTile(
                  leading: Checkbox(
                    value: everyDayTaskAchieved[index], // 動的な値
                    onChanged: (bool? value) {
                      setState(() {
                        everyDayTaskAchieved[index] = value ?? false;
                      });
                    },
                  ),
                  title: Text(everyDayTask[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {},
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchEveryDayTask() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('everydaytask')
        .snapshots()
        .listen((snapshot) {
      List<String> tmpEveryDayTask = [];
      List<bool> tmpEveryDayTaskAchieved = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();
        tmpEveryDayTask.add(data['task']);
        tmpEveryDayTaskAchieved.add(false);
      }
      setState(() {
        everyDayTask = tmpEveryDayTask;
        everyDayTaskAchieved = tmpEveryDayTaskAchieved;
      });
    });
  }
}
