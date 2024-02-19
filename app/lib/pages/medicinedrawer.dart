import 'package:flutter/material.dart';
import 'package:app/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:path/path.dart' as path;

class MedicinePageDrawer extends StatefulWidget {
  const MedicinePageDrawer({super.key, required this.user});
  final User user;
  @override
  MedicinePageDrawerState createState() => MedicinePageDrawerState();
}

class MedicinePageDrawerState extends State<MedicinePageDrawer> {
  List<List<dynamic>> csvData = [];
  List<String> medicineNames = [];
  List<String> searchResults = [];
  Map<String, String> imgNameMap = {}; // {medicineName: imgName}

  void _loadData() async {
    // load CSV DATA
    List<List<dynamic>> tmpCsvData =
        await loadCsvData('assets/medicine.csv'); // CSVデータの使用
    setState(() {
      csvData = tmpCsvData;
    });
    List<String> tmpMedicineNames = [];
    Map<String, String> tmpImgNameMap = {};
    for (var index = 1; index < csvData.length; ++index) {
      tmpMedicineNames.add(csvData[index][0]);
      tmpImgNameMap[csvData[index][0]] = path.basename(csvData[index][2]);
    }
    setState(() {
      medicineNames = tmpMedicineNames;
      imgNameMap = tmpImgNameMap;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

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
            child: const Text('処方薬の設定'),
          ),
          TextField(
            onChanged: (text) {
              //検索候補を調べる
              List<String> filteredMedicines = medicineNames.where((medicine) {
                if (text != "") {
                  return medicine.startsWith(text) || medicine.contains(text);
                } else {
                  return false;
                }
              }).toList();
              setState(() {
                searchResults = filteredMedicines;
              });
            },
            decoration: const InputDecoration(
              labelText: '薬の名前を入力してください',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: min(searchResults.length * 50, 200),
            child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                        title: Text(searchResults[index]),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return MedicineTimeSettingDialog(
                                  medicineName: searchResults[index],
                                  saveName: imgNameMap[searchResults[index]],
                                  user: widget.user,
                                );
                              });
                        }),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class MedicineTimeSettingDialog extends StatefulWidget {
  const MedicineTimeSettingDialog(
      {super.key,
      required this.medicineName,
      required this.saveName,
      required this.user});
  final String medicineName;
  final String? saveName;
  final User user;

  @override
  MedicineTimeSettingDialogState createState() =>
      MedicineTimeSettingDialogState();
}

class MedicineTimeSettingDialogState extends State<MedicineTimeSettingDialog> {
  bool isMorningSelected = false;
  bool isNoonSelected = false;
  bool isNightSelected = false;
  final List<int> _takenMedicineCandidates = [1, 2, 3, 4, 5];
  final List<int> _takenMedicines = [1, 1, 1];

  void _addData(String medicineName) {
    CollectionReference collection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('medicine');
    collection.doc(medicineName).set({
      "medicine": medicineName,
      "imgPath": widget.saveName,
      "medicineTime": [isMorningSelected, isNoonSelected, isNightSelected],
      "takenMedicine": _takenMedicines
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.medicineName}を飲む時間帯'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                      value: isMorningSelected,
                      onChanged: (value) {
                        setState(() {
                          isMorningSelected = value;
                        });
                      },
                      title: const Row(
                        children: [
                          Icon(Icons.wb_sunny),
                          SizedBox(width: 8),
                          Text("朝"),
                        ],
                      )),
                ),
                if (isMorningSelected)
                  DropdownButton<int>(
                    value: _takenMedicines[0],
                    hint: const Text('Select'),
                    onChanged: (newValue) {
                      setState(() {
                        _takenMedicines[0] = newValue!;
                      });
                    },
                    items: _takenMedicineCandidates
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value'),
                      );
                    }).toList(),
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                      value: isNoonSelected,
                      onChanged: (value) {
                        setState(() {
                          isNoonSelected = value;
                        });
                      },
                      title: const Row(
                        children: [
                          Icon(Icons.wb_cloudy),
                          SizedBox(width: 8),
                          Text("昼"),
                        ],
                      )),
                ),
                if (isNoonSelected)
                  DropdownButton<int>(
                    value: _takenMedicines[1],
                    hint: const Text('Select'),
                    onChanged: (newValue) {
                      setState(() {
                        _takenMedicines[1] = newValue!;
                      });
                    },
                    items: _takenMedicineCandidates
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value'),
                      );
                    }).toList(),
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                      value: isNightSelected,
                      onChanged: (value) {
                        setState(() {
                          isNightSelected = value;
                        });
                      },
                      title: const Row(
                        children: [
                          Icon(Icons.nights_stay),
                          SizedBox(width: 8),
                          Text("夜"),
                        ],
                      )),
                ),
                if (isNightSelected)
                  DropdownButton<int>(
                    value: _takenMedicines[2],
                    hint: const Text('Select'),
                    onChanged: (newValue) {
                      setState(() {
                        _takenMedicines[2] = newValue!;
                      });
                    },
                    items: _takenMedicineCandidates
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value'),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('保存'),
          onPressed: () {
            // ここで設定を保存する処理を記述
            _addData(widget.medicineName);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
