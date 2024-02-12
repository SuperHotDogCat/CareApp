import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages.dart';
import 'config.dart';
import 'utils.dart';
//ios build, firebase iosを追加して手順に従う->https://qiita.com/kasa_le/items/fed9f25b92091bd162ce & https://zenn.dev/popy1017/articles/b9f3e46b5efeb79af1f7

final configrations = Configurations();
Future<void> init() async {
  //これ絶対に必要, initもしろ
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: configrations.apiKey,
          appId: configrations.appId,
          messagingSenderId: configrations.messagingSenderId,
          projectId: configrations.projectId));
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  init(); //Firebase Initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // これを追
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LogInPage(),
    );
  }
}

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.user});

  final String title;
  final User user;

  @override
  State<MyHomePage> createState() => _MyHomePageState(user: user);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({required this.user});
  User user;

  var pageIndex = 0;
  void _onTapBottomNavigationBar(int index) {
    setState(() {
      pageIndex = index; //page遷移, 選択時の色遷移をする。
    });
  }

  void _onTapAppBar(int index) {
    setState(() {
      pageIndex = index; //page遷移, 選択時の色遷移をする。
    });
  }

  final settingsIndex = 2;
  final homeIndex = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _pages = [
      CalendarPageBody(
        title: "Calender",
        user: user,
      ),
      MedicinePageBody(
        title: "Medicine",
        user: user,
      ),
      SettingsPageBody(
        title: "Settings",
        user: user,
      ),
      HomePageBody(title: "Home", user: user)
    ];

    final _drawers = [
      CalendarPageDrawer(),
      MedicinePageDrawer(),
      SettingsPageDrawer(),
      HomePageDrawer(),
    ];

    return Scaffold(
      key: _scaffoldKey, 
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(icon: Icon(Icons.add), onPressed: () {
          // Drawerを開く
          _scaffoldKey.currentState?.openDrawer();
        },), // plusアイコンを使用
        title: Text(widget.title),
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
      body: _pages[pageIndex],
      // To do: floating buttonの追加, medicine pageでは恐らくflutter側からfirebaseを呼び出す処理が挟まれる。
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_services), label: 'Medicine'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          //BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
        onTap: _onTapBottomNavigationBar,
        selectedItemColor: Colors.pink,
        currentIndex: pageIndex, //これも設定しないとページ遷移時の色が変化しない。
        type: BottomNavigationBarType.fixed,
      ),
      drawer: _drawers[pageIndex]
    );
  }
}
