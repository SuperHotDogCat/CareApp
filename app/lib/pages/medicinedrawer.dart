import 'package:flutter/material.dart';
import 'package:app/utils.dart';
import 'dart:math';

class MedicinePageDrawer extends StatefulWidget {
  MedicinePageDrawer({super.key});
  @override
  _MedicinePageDrawerState createState() => _MedicinePageDrawerState();
}

class _MedicinePageDrawerState extends State<MedicinePageDrawer> {
  List<List<dynamic>> csvData = [];
  List<String> medicineNames = [];
  List<String> searchResults = [];

  void _loadData() async {
    // load CSV DATA
    List<List<dynamic>> tmpCsvData =
        await loadCsvData('assets/medicine.csv'); // CSVデータの使用
    setState(() {
      csvData = tmpCsvData;
    });
    List<String> tmpMedicineNames = [];
    for (var index = 1; index < csvData.length; ++index) {
      tmpMedicineNames.add(csvData[index][0]);
    }
    setState(() {
      medicineNames = tmpMedicineNames;
    });
  }

  @override
  void initState() {
    _loadData();
  }

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
            decoration: InputDecoration(
              labelText: '薬の名前を入力してください',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          SizedBox(
            height: min(searchResults.length * 50, 200),
            child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(8),
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
                                    medicineName: searchResults[index]);
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
  MedicineTimeSettingDialog({required this.medicineName});
  final String medicineName;

  @override
  _MedicineTimeSettingDialogState createState() =>
      _MedicineTimeSettingDialogState();
}

class _MedicineTimeSettingDialogState extends State<MedicineTimeSettingDialog> {
  bool isMorningSelected = false;
  bool isNoonSelected = false;
  bool isNightSelected = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.medicineName}を飲む時間帯'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            SwitchListTile(
              title: Row(
                children: [
                  Icon(Icons.wb_sunny),
                  SizedBox(width: 8),
                  Text("朝"),
                ],
              ),
              value: isMorningSelected,
              onChanged: (value) {
                setState(() {
                  isMorningSelected = value;
                });
              },
            ),
            SwitchListTile(
              title: Row(
                children: [
                  Icon(Icons.wb_cloudy),
                  SizedBox(width: 8),
                  Text("昼"),
                ],
              ),
              value: isNoonSelected,
              onChanged: (value) {
                setState(() {
                  isNoonSelected = value;
                });
              },
            ),
            SwitchListTile(
              title: Row(
                children: [
                  Icon(Icons.nights_stay),
                  SizedBox(width: 8),
                  Text("夜"),
                ],
              ),
              value: isNightSelected,
              onChanged: (value) {
                setState(() {
                  isNightSelected = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('キャンセル'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('保存'),
          onPressed: () {
            // ここで設定を保存する処理を記述
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
