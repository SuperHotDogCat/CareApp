import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicinePageBody extends StatefulWidget {
  const MedicinePageBody({super.key, required this.title, required this.user});
  final String title;
  final User user;

  @override
  State<MedicinePageBody> createState() => _MedicinePageState(user: user);
}

class _MedicinePageState extends State<MedicinePageBody> {
  _MedicinePageState({required this.user});
  // 薬リストのデータ
  List<String> medicineList = ["コンサータ"];
  List<String> imagesList = ["assets/1179009G1022_000.jpg"];
  User user;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
      itemCount: medicineList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Image.asset(imagesList[index]),
            title: Text(medicineList[index]),
          ),
        );
      },
    ));
  }
}
