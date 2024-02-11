import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages.dart';
import 'config.dart';
import 'utils.dart';

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
  init();
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Log in"),
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
                          print(result.user!.uid);
                          return MyHomePage(title: "CareApp");
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
                            return MyHomePage(title: "CareApp");
                          }),
                        );
                      } else {
                        infoText = "パスワードの確認をしてください。";
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
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final _pages = [
      CalendarPageBody(title: "Calender"),
      MedicinePageBody(title: "Medicine"),
      SettingsPageBody(title: "Settings"),
      HomePageBody(title: "Home")
    ];

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
    );
  }
}
