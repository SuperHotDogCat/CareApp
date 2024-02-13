import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';
import 'myhomepage.dart';
import 'package:app/utils.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';
  String passwordConfirmation = '';
  String userName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Sign Up"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return LogInPage();
              }));
            },
            icon: Icon(Icons.chevron_left),
            tooltip: "ログイン画面に戻る",
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                  decoration: InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  }),
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード確認'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    passwordConfirmation = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '名前'),
                onChanged: (String value) {
                  setState(() {
                    userName = value;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  child: Text("ユーザー登録"),
                  onPressed: () async {
                    try {
                      if (password == passwordConfirmation) {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final result =
                            await auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        var userBasicProfile = {"name": userName};
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