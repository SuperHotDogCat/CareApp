import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicinePageBody extends StatefulWidget {
  const MedicinePageBody({super.key, required this.title, required this.user});
  final String title;
  final User user;

  @override
  MedicinePageState createState() => MedicinePageState();
}

class MedicinePageState extends State<MedicinePageBody> {
  // 薬リストのデータ
  List<String> medicineList = [];
  List<String> imagesList = [];
  List<List<bool>> boolList = [];
  List<String> personList = [];
  //for carers
  List<String> carersMedicineList = [];
  List<String> carersImagesList = [];
  List<List<bool>> carersBoolList = [];
  List<String> carersPersonList = [];
  String selfName = "";

  void _fetchData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('medicine')
        .snapshots()
        .listen((snapshot) async {
      List<String> tmpMedicineList = [];
      List<String> tmpImagesList = [];
      List<List<bool>> tmpBoolList = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();
        tmpMedicineList.add(data["medicine"]);
        tmpImagesList.add('assets/medimages/${data["imgPath"]}');
        List<bool> bools =
            data["medicineTime"].whereType<bool>().toList(); //こうキャストしなければいけない
        tmpBoolList.add(bools);
      }
      setState(() {
        medicineList.clear();
        imagesList.clear();
        boolList.clear();
        medicineList.addAll(tmpMedicineList);
        imagesList.addAll(tmpImagesList);
        boolList.addAll(tmpBoolList);
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .snapshots()
          .listen((userData) {
        if (userData.exists) {
          Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
          String tmpSelfName = data["name"];
          List<String> tmpPersonList = List.generate(
            tmpMedicineList.length,
            (index) => data["name"].toString(),
          );
          setState(() {
            personList.clear();
            personList = tmpPersonList;
            selfName = tmpSelfName;
          });
        }
      });
    });
  }

  void _fetchCarersData() async {
    //To do: Careしている人のデータも取る
    //Map<String, String> tmpCarersNames = {};
    List<String> tmpCarersNames = [];
    List<String> tmpCarersIds = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('carers')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        tmpCarersNames.add(data["name"]);
        tmpCarersIds.add(data["id"]);
      }
      //iteration per carers
      for (var index = 0; index < tmpCarersNames.length; ++index) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(tmpCarersIds[index])
            .collection('medicine')
            .snapshots()
            .listen((snapshot) {
          List<String> tmpMedicineList = [];
          List<String> tmpImagesList = [];
          List<List<bool>> tmpBoolList = [];
          List<String> tmpPersonList = [];
          for (var doc in snapshot.docs) {
            var data = doc.data();
            tmpMedicineList.add(data["medicine"]);
            tmpImagesList.add("assets/medimages/${data["imgPath"]}");
            List<bool> bools = data["medicineTime"]
                .whereType<bool>()
                .toList(); //こうキャストしなければいけない
            tmpBoolList.add(bools);
            tmpPersonList.add(tmpCarersNames[index]);
          }
          setState(() {
            carersMedicineList.addAll(tmpMedicineList);
            carersImagesList.addAll(tmpImagesList);
            carersBoolList.addAll(tmpBoolList);
            carersPersonList.addAll(tmpPersonList);
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

  Widget _timeRow(List<bool> boolListContent, String userName) {
    List<Widget> widgets = [];
    widgets.add(Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(4.0),
      child: Text(
        userName,
        style: const TextStyle(fontSize: 14.0),
      ),
    ));
    widgets.add(const SizedBox(
      width: 8,
    ));
    if (boolListContent[0] == true) {
      widgets.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.pink[200],
          ),
          padding: const EdgeInsets.all(4.0),
          child: const Text(
            'Morning',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      );
      widgets.add(const SizedBox(
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
          padding: const EdgeInsets.all(4.0),
          child: const Text(
            'Lunch',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      );
      widgets.add(const SizedBox(
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
          padding: const EdgeInsets.all(4.0),
          child: const Text(
            'Dinner',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      );
    }
    return SizedBox(
      width: 200,
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widgets,
      ),
    );
  }

  Widget medicineImageFromAsset(String imgPath) {
    if (imgPath.contains("noimage")) {
      return const SizedBox(
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
    super.initState();
    _fetchData();
    _fetchCarersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
      itemCount: medicineList.length + carersMedicineList.length,
      itemBuilder: (context, index) {
        if (index < medicineList.length) {
          try {
            return Card(
              child: ListTile(
                leading: medicineImageFromAsset(imagesList[index]),
                title: Text(medicineList[index]),
                subtitle: _timeRow(boolList[index], personList[index]),
                trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _deleteMedicineData(widget.user.uid, medicineList[index]);
                    }),
                onTap: () {
                  // 薬の編集画面
                },
              ),
            );
          } catch (e) {
            return const Text('...Loading');
          }
        } else {
          return Card(
            child: ListTile(
              leading: medicineImageFromAsset(
                  carersImagesList[index - medicineList.length]),
              title: Text(carersMedicineList[index - medicineList.length]),
              subtitle: _timeRow(carersBoolList[index - medicineList.length],
                  carersPersonList[index - medicineList.length]),
              trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('警告'),
                            content: const Text('他の人が飲んでいる薬をリストから消すことはできません'),
                            actions: [
                              TextButton(
                                child:const  Text('いいえ'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // ダイアログを閉じる
                                },
                              ),
                              TextButton(
                                child: const Text('はい'),
                                onPressed: () {
                                  // はいがタップされた時の処理
                                  Navigator.of(context).pop(); // ダイアログを閉じる
                                },
                              ),
                            ],
                          );
                        });
                  }),
              onTap: () {
                // 薬の編集画面
              },
            ),
          );
        }
      },
    ));
  }
}
