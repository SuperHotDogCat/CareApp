import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';
import 'myhomepage.dart';
import 'package:app/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUpPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';
  String passwordConfirmation = '';
  String userName = '';

  // DateTime型で変数を初期化、ローカルタイムで朝8時に設定
  DateTime _breakfastTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 0);
  DateTime _lunchTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0);
  DateTime _dinnerTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 0);

  void _mealTimePicker(String mealType, DateTime mealTime,
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Sign Up"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return const LogInPage();
              }));
            },
            icon: const Icon(Icons.chevron_left),
            tooltip: "ログイン画面に戻る",
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                  decoration: const InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  }),
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード確認'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    passwordConfirmation = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '名前'),
                onChanged: (String value) {
                  setState(() {
                    userName = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Column(children: [
                ListTile(
                  onTap: () => _mealTimePicker("breakfastTime", _breakfastTime,
                      (newTime) {
                    _breakfastTime = newTime;
                  }),
                  title: const Text('朝食の時間を設定'),
                  leading: const Icon(Icons.watch),
                ),
                const Divider()
              ]),
              Column(children: [
                ListTile(
                  onTap: () =>
                      _mealTimePicker("lunchTime", _lunchTime, (newTime) {
                    _lunchTime = newTime;
                  }),
                  title: const Text('昼食の時間を設定'),
                  leading: const Icon(Icons.watch),
                ),
                const Divider()
              ]),
              Column(children: [
                ListTile(
                  onTap: () =>
                      _mealTimePicker("dinnerTime", _dinnerTime, (newTime) {
                    _dinnerTime = newTime;
                  }),
                  title: const Text('夜食の時間を設定'),
                  leading: const Icon(Icons.watch),
                ),
                const Divider()
              ]),
              Container(
                padding: const EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  child: const Text("ユーザー登録"),
                  onPressed: () async {
                    try {
                      if (password == passwordConfirmation) {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final result =
                            await auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        var userBasicProfile = {
                          "name": userName,
                          "breakfastTime": _breakfastTime,
                          "lunchTime": _lunchTime,
                          "dinnerTime": _dinnerTime
                        };
                        //createUserBasicData
                        createUserBasicData(result.user!, userBasicProfile);
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return MyHomePage(
                                title: "CareApp", user: result.user!);
                          }),
                        );
                      } else {
                        setState(() {
                          infoText = "パスワードの確認をしてください。";
                        });
                      }
                    } catch (e) {
                      setState(() {
                        infoText = "ユーザー登録に失敗しました。${e.toString()}";
                      });
                    }
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
