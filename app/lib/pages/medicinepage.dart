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
  List<List<int>> takenMedicineList = [];
  List<String> personList = [];
  //for careRecipients
  List<String> careRecipientsMedicineList = [];
  List<String> careRecipientsImagesList = [];
  List<List<bool>> careRecipientsBoolList = [];
  List<String> careRecipientsPersonList = [];
  List<List<int>> careRecipientsTakenMedicineList = [];
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
      List<List<int>> tmpTakenMedicineList = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();
        tmpMedicineList.add(data["medicine"]);
        tmpImagesList.add('assets/medimages/${data["imgPath"]}');
        List<bool> bools =
            data["medicineTime"].whereType<bool>().toList(); //こうキャストしなければいけない
        tmpBoolList.add(bools);
        List<int> takenMedicines =
            data["takenMedicine"].whereType<int>().toList();
        tmpTakenMedicineList.add(takenMedicines);
      }
      setState(() {
        medicineList.clear();
        imagesList.clear();
        boolList.clear();
        medicineList.addAll(tmpMedicineList);
        imagesList.addAll(tmpImagesList);
        boolList.addAll(tmpBoolList);
        takenMedicineList.addAll(tmpTakenMedicineList);
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

  void _fetchCareRecipientsData() async {
    //To do: Careしている人のデータも取る
    //Map<String, String> tmpCareRecipientsNames = {};
    List<String> tmpCareRecipientsNames = [];
    List<String> tmpCareRecipientsIds = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('carerecipients')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        tmpCareRecipientsNames.add(data["name"]);
        tmpCareRecipientsIds.add(data["id"]);
      }
      //iteration per careRecipients
      for (var index = 0; index < tmpCareRecipientsNames.length; ++index) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(tmpCareRecipientsIds[index])
            .collection('medicine')
            .snapshots()
            .listen((snapshot) {
          List<String> tmpMedicineList = [];
          List<String> tmpImagesList = [];
          List<List<bool>> tmpBoolList = [];
          List<String> tmpPersonList = [];
          List<List<int>> tmpTakenMedicineList = [];

          for (var doc in snapshot.docs) {
            var data = doc.data();
            tmpMedicineList.add(data["medicine"]);
            tmpImagesList.add("assets/medimages/${data["imgPath"]}");
            List<bool> bools = data["medicineTime"]
                .whereType<bool>()
                .toList(); //こうキャストしなければいけない
            tmpBoolList.add(bools);
            tmpPersonList.add(tmpCareRecipientsNames[index]);
            List<int> takenMedicines =
                data["takenMedicine"].whereType<int>().toList();
            tmpTakenMedicineList.add(takenMedicines);
          }
          setState(() {
            careRecipientsMedicineList.addAll(tmpMedicineList);
            careRecipientsImagesList.addAll(tmpImagesList);
            careRecipientsBoolList.addAll(tmpBoolList);
            careRecipientsPersonList.addAll(tmpPersonList);
            careRecipientsTakenMedicineList.addAll(tmpTakenMedicineList);
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

  Widget _timeRow(
      List<bool> boolListContent, String userName, List<int> takenMedicine) {
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
          child: Text(
            '朝 個数 ${takenMedicine[0]}',
            style: const TextStyle(fontSize: 14.0),
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
          child: Text(
            '昼 個数 ${takenMedicine[1]}',
            style: const TextStyle(fontSize: 14.0),
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
          child: Text(
            '夜 個数 ${takenMedicine[2]}',
            style: const TextStyle(fontSize: 14.0),
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
    _fetchCareRecipientsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
      itemCount: medicineList.length + careRecipientsMedicineList.length,
      itemBuilder: (context, index) {
        if (index < medicineList.length) {
          try {
            return Card(
              child: ListTile(
                leading: medicineImageFromAsset(imagesList[index]),
                title: Text(medicineList[index]),
                subtitle: _timeRow(boolList[index], personList[index],
                    takenMedicineList[index]),
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
            return const Text('...読み込み中');
          }
        } else {
          return Card(
            child: ListTile(
              leading: medicineImageFromAsset(
                  careRecipientsImagesList[index - medicineList.length]),
              title:
                  Text(careRecipientsMedicineList[index - medicineList.length]),
              subtitle: _timeRow(
                  careRecipientsBoolList[index - medicineList.length],
                  careRecipientsPersonList[index - medicineList.length],
                  careRecipientsTakenMedicineList[index - medicineList.length]),
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
                                child: const Text('いいえ'),
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
