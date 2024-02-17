import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<String> medicineList = [];
  List<String> imagesList = [];
  User user;

  void _fetchData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('medicine')
        .snapshots()
        .listen((snapshot) {
      List<String> tmpMedicineList = [];
      List<String> tmpImagesList = [];
      for (var doc in snapshot.docs) {
        var data = doc.data();
        tmpMedicineList.add(data["medicine"]);
        tmpImagesList.add("assets/medimages/" + data["imgPath"]);
      }
      setState(() {
        medicineList = tmpMedicineList;
        imagesList = tmpImagesList;
      });
    });
  }

  @override
  void initState() {
    _fetchData();
  }

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
