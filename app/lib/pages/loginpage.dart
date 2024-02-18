import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'myhomepage.dart';
import 'signuppage.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Log in"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'パスワード'),
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      password = value;
                    });
                  },
                  autofillHints: [AutofillHints.password],
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
                    child: Text("ログイン"),
                    onPressed: () async {
                      try {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final result = await auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return MyHomePage(
                                title: "CareApp", user: result.user!);
                          }),
                        );
                      } catch (e) {
                        setState(() {
                          infoText = "ログインに失敗しました。${e.toString()}";
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      child: Text("ユーザー登録"),
                      onPressed: () async {
                        await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return SignUpPage();
                        }));
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
