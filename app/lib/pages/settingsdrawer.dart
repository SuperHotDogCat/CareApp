import 'package:flutter/material.dart';

class SettingsPageDrawer extends StatefulWidget {
  SettingsPageDrawer({super.key});
  @override
  _SettingsPageDrawerState createState() => _SettingsPageDrawerState();
}

class _SettingsPageDrawerState extends State<SettingsPageDrawer> {
  @override
  Widget build(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Settings Drawer Header'),
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
