import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'myhomepage.dart';
import 'signuppage.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});
  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
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
        title: const Text("ログイン"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'パスワード'),
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      password = value;
                    });
                  },
                  autofillHints: const [AutofillHints.password],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  // メッセージ表示
                  child: Text(infoText),
                ),
                const SizedBox(height: 8),
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        child: const Text("ログイン"),
                        onPressed: () async {
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          await auth
                              .signInWithEmailAndPassword(
                                  email: email, password: password)
                              .then(
                            (result) async {
                              try {
                                await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return MyHomePage(
                                      title: "CareLink", user: result.user!);
                                }));
                              } catch (e) {
                                setState(() {
                                  infoText = "ログインに失敗しました。${e.toString()}";
                                });
                              }
                            },
                          );
                        })),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      child: const Text("ユーザー登録"),
                      onPressed: () async {
                        await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return const SignUpPage();
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
