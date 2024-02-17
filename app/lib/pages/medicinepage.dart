import 'dart:html';

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
  List<List<bool>> boolList = [];
  List<String> personList = [];
  String selfName = "";
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
      List<List<bool>> tmpBoolList = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();
        tmpMedicineList.add(data["medicine"]);
        tmpImagesList.add("assets/medimages/" + data["imgPath"]);
        List<bool> bools =
            data["medicineTime"].whereType<bool>().toList(); //こうキャストしなければいけない
        tmpBoolList.add(bools);
      }

      setState(() {
        medicineList = tmpMedicineList;
        imagesList = tmpImagesList;
        boolList = tmpBoolList;
      });
    });

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<String> tmpPersonList = [];
      String tmpSelfName = "";
      for (var index = 0; index < medicineList.length; index++) {
        tmpPersonList.add(data["name"]);
        tmpSelfName = data["name"];
      }
      setState(() {
        personList = tmpPersonList;
        selfName = tmpSelfName;
      });
    }
  }

  void _fetchCarersData() async {
    //To do: Careしている人のデータも取る
    //Map<String, String> tmpCarersNames = {};
    List<String> tmpCarersNames = [];
    List<String> tmpCarersIds = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carers')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        tmpCarersNames.add(data["name"]);
        tmpCarersIds.add(data["id"]);
      }
      for (var index = 0; index < tmpCarersNames.length; ++index) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(tmpCarersIds[index])
            .collection('medicine')
            .snapshots()
            .listen((snapshot) {
          List<String> tmpMedicineList = medicineList;
          List<String> tmpImagesList = imagesList;
          List<List<bool>> tmpBoolList = boolList;
          List<String> tmpPersonList = personList;
          for (var doc in snapshot.docs) {
            var data = doc.data();
            tmpMedicineList.add(data["medicine"]);
            tmpImagesList.add("assets/medimages/" + data["imgPath"]);
            List<bool> bools = data["medicineTime"]
                .whereType<bool>()
                .toList(); //こうキャストしなければいけない
            tmpBoolList.add(bools);
            tmpPersonList.add(tmpCarersNames[index]);
          }
          setState(() {
            medicineList = tmpMedicineList;
            imagesList = tmpImagesList;
            boolList = tmpBoolList;
            personList = tmpPersonList;
          });
        });
      }
    });
  }

  void _deleteMedicineData(String userId, String medicineName) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('medicine')
        .doc(medicineName)
        .delete();
  }

  Widget _timeRow(List<bool> boolListContent) {
    List<Widget> widgets = [];
    if (boolListContent[0] == true) {
      widgets.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.pink[200],
          ),
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Morning',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      );
      widgets.add(SizedBox(
        width: 8,
      ));
    }
    if (boolListContent[1] == true) {
      widgets.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.yellow[200],
          ),
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Lunch',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      );
      widgets.add(SizedBox(
        width: 8,
      ));
    }
    if (boolListContent[2] == true) {
      widgets.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blue[200],
          ),
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Dinner',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      );
    }
    return Row(
      children: widgets,
    );
  }

  Widget medicineImageFromAsset(String imgPath) {
    if (imgPath.contains("noimage")) {
      return SizedBox(
        width: 50,
        height: 50,
        child: Text("No Medicine Image"),
      );
    } else {
      return Image.asset(imgPath);
    }
  }

  @override
  void initState() {
    _fetchData();
    _fetchCarersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
      itemCount: medicineList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: medicineImageFromAsset(imagesList[index]),
            title: Text(medicineList[index]),
            subtitle: _timeRow(boolList[index]),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () =>
                  _deleteMedicineData(user.uid, medicineList[index]),
            ),
            onTap: () {
              // 薬の編集画面
            },
          ),
        );
      },
    ));
  }
}
