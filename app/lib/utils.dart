import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages.dart';
import 'config.dart';

void createUserBasicData(User user, Map userBasicProfile) {
  // Firestoreのインスタンスを取得
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  users.doc(user.uid).set({
    "id": user.uid,
    "name": userBasicProfile["name"],
  });
  CollectionReference medicine = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('medicine');
  medicine.doc('medicine').set({"medicine": <String>[]});
  CollectionReference schedule = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('schedule');
  schedule.doc('schedule').set({
    'schedule': <Map<DateTime, String>>[] // key: DateTime, value: Content
  });
  CollectionReference caregivers = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('caregivers');
  caregivers.doc('caregivers').set({
    'caregivers': <Map<String, String>>[] // key: uid, value: name
  });
}

Widget RealTimeStreamDataWidget(stream, builder) {
  return StreamBuilder<QuerySnapshot>(stream: stream, builder: builder);
}

Widget RealTimeDataWidget(stream, builder) {
  return StreamBuilder(stream: stream, builder: builder);
}

Stream<DocumentSnapshot> fetchUserData(User user) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return firestore.collection('users').doc(user.uid).snapshots();
}

Stream<DocumentSnapshot> fetchUserDataTest() {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return firestore
      .collection('users')
      .doc("azuxHrjNPFhkGkInWA0tQJXgpWG3")
      .snapshots();
}
