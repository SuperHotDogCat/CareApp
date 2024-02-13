import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';


class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key, required this.title, required this.user});
  final String title;
  final User user;

  @override
  State<HomePageBody> createState() => _HomePageState(user: user);
}

class _HomePageState extends State<HomePageBody> {
  _HomePageState({required this.user});
  User user;
  final remindDropDownItems = [
    DropdownMenuItem(
      child: Text("15 min"),
      value: 15,
    ),
    DropdownMenuItem(
      child: Text("30 min"),
      value: 30,
    ),
    DropdownMenuItem(
      child: Text("45 min"),
      value: 45,
    ),
    DropdownMenuItem(
      child: Text("60 min"),
      value: 60,
    ),
  ];

  var isSelectedValue = 15;

  void remindDropDownChanged(int? value) {
    setState(() {
      isSelectedValue = value!;
    });
  }

  List<String> caregivers = List.generate(
      10,
      (_) => String.fromCharCodes(
          List.generate(5, (_) => Random().nextInt(26) + 97)));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                '通知の頻度',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              DropdownButton(
                items: remindDropDownItems,
                onChanged: (value) => remindDropDownChanged(value),
                value: isSelectedValue,
              ),
              Text(
                '共同介護者',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: caregivers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(caregivers[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}