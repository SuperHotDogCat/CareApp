import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'calendarpage.dart';
import 'medicinepage.dart';
import 'settingspage.dart';
import 'homepage.dart';
import 'calendardrawer.dart';
import 'loginpage.dart';
import 'medicinedrawer.dart';
import 'settingsdrawer.dart';
import 'homedrawer.dart';

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
      HomePageBody(
        title: "Home",
        user: user,
        scaffoldState: _scaffoldKey,
      )
    ];

    //To do: If our app has a page that does not need a drawer, please remove it.
    final _drawers = [
      CalendarPageDrawer(
        user: user,
      ),
      MedicinePageDrawer(),
      SettingsPageDrawer(),
      HomePageDrawer(
        user: user,
      ),
    ];

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ), // plusアイコンを使用
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
        drawer: _drawers[pageIndex]);
  }
}
