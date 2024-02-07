import 'package:flutter/material.dart';

class CalendarPageBody extends StatelessWidget {
  const CalendarPageBody({super.key,});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'To do: write calendar page',
            ),
            Text(
              'Calendar',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      );
  }
}

class MedicinePageBody extends StatefulWidget {
  const MedicinePageBody({super.key, required this.title});
  final String title;

  @override
  State<MedicinePageBody> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePageBody> {
  // 薬リストのデータ
  List<String> medicineList = ["コンサータ"];
  List<String> imagesList = ["assets/1179009G1022_000.jpg"];

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
    child: ListView.builder(
      itemCount: medicineList.length,
      itemBuilder: (context, index){
        return Card(
          child: ListTile(
            leading: Image.asset(imagesList[index]),
            title: Text(medicineList[index]),
          ),
        );
      },
    )
    );
  }
}

class SettingsPageBody extends StatefulWidget {
  const SettingsPageBody({super.key, required this.title});
  final String title;

  @override
  State<SettingsPageBody> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPageBody> {
  // 薬リストのデータ
  List<String> medicineList = ["hogehoge"];
  List<String> imagesList = ["assets/1179009G1022_000.jpg"];
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
    child: ListView.builder(
      itemCount: medicineList.length,
      itemBuilder: (context, index){
        return Card(
          child: ListTile(
            leading: Image.asset(imagesList[index]),
            title: Text(medicineList[index]),
          ),
        );
      },
    )
    );
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key, required this.title});
  final String title;

  @override
  State<HomePageBody> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageBody> {
  // 薬リストのデータ
  List<String> medicineList = ["yaayaa"];
  List<String> imagesList = ["assets/1179009G1022_000.jpg"];
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
    child: ListView.builder(
      itemCount: medicineList.length,
      itemBuilder: (context, index){
        return Card(
          child: ListTile(
            leading: Image.asset(imagesList[index]),
            title: Text(medicineList[index]),
          ),
        );
      },
    )
    );
  }
}