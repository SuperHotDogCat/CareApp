import 'package:flutter/material.dart';

class MedicinePageDrawer extends StatefulWidget {
  MedicinePageDrawer({super.key});
  @override
  _MedicinePageDrawerState createState() => _MedicinePageDrawerState();
}

class _MedicinePageDrawerState extends State<MedicinePageDrawer> {
  @override
  Widget build(context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Medicine Drawer Header'),
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