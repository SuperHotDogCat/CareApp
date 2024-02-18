import 'package:flutter/material.dart';

class HomePageDrawer extends StatefulWidget {
  const HomePageDrawer({super.key});
  @override
  HomePageDrawerState createState() => HomePageDrawerState();
}

class HomePageDrawerState extends State<HomePageDrawer> {
  @override
  Widget build(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: const Text('Home Drawer Header'),
          ),
          ListTile(
            title: const Text('項目 1'),
            onTap: () {
              // Drawer内の項目がタップされたときの動作
              Navigator.pop(context); // Drawerを閉じる
            },
          ),
          ListTile(
            title: const Text('項目 2'),
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
