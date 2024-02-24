import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

void createUserBasicData(User user, Map userBasicProfile) {
  // Firestoreのインスタンスを取得
  Map<String, dynamic> initialUserData = {
    "id": user.uid,
    ...userBasicProfile,
  };
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  users.doc(user.uid).set(initialUserData);
}

Stream<DocumentSnapshot> fetchUserDataSnapShots(User user) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return firestore.collection('users').doc(user.uid).snapshots();
}

Future<List<List<dynamic>>> loadCsvData(String path) async {
  final csvData = await rootBundle.loadString(path);
  List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);
  return csvTable;
}
