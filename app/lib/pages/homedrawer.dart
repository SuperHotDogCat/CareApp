import 'package:flutter/material.dart';

class HomePageDrawer extends StatefulWidget {
  HomePageDrawer({super.key});
  @override
  _HomePageDrawerState createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  @override
  Widget build(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Home Drawer Header'),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          ListTile(
            title: Text('項目 1'),
            onTap: () {
              // Drawer内の項目がタップされたときの動作
              Navigator.pop(context); // Drawerを閉じる
            },
          ),
          ListTile(
            title: Text('項目 2'),
            onTap: () {
              // Drawer内の項目がタップされたときの動作
              Navigator.pop(context); // Drawerを閉じる
            },
          ),
        ],
      ),
    );
  }
}
