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
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var pageIndex = 0;
  void _onTapBottomNavigationBar(int index) {
    setState(() {
      pageIndex = index; //page遷移, 選択時の色遷移をする。
    });
  }

  final homeIndex = 2;
  final settingsIndex = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final pages = [
      CalendarPageBody(
        title: "Calender",
        user: widget.user,
      ),
      MedicinePageBody(
        title: "Medicine",
        user: widget.user,
      ),
      HomePageBody(
        title: "Settings",
        user: widget.user,
      ),
      SettingsPageBody(
        title: "Home",
        user: widget.user,
        scaffoldState: _scaffoldKey,
      )
    ];

    //To do: If our app has a page that does not need a drawer, please remove it.
    final drawers = [
      CalendarPageDrawer(
        user: widget.user,
      ),
      MedicinePageDrawer(
        user: widget.user,
      ),
      HomePageDrawer(user: widget.user),
      SettingsPageDrawer(
        user: widget.user,
      ),
    ];

    final leadings = [
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
    ];

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: leadings[pageIndex], // plusアイコンを使用
          title: Text(widget.title),
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
        body: pages[pageIndex],
        // To do: floating buttonの追加, medicine pageでは恐らくflutter側からfirebaseを呼び出す処理が挟まれる。
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: 'Calendar'),
            BottomNavigationBarItem(
                icon: Icon(Icons.medical_services), label: 'Medicine'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
            //BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          ],
          onTap: _onTapBottomNavigationBar,
          selectedItemColor: Colors.pink,
          currentIndex: pageIndex, //これも設定しないとページ遷移時の色が変化しない。
          type: BottomNavigationBarType.fixed,
        ),
        drawer: drawers[pageIndex]);
  }
}
