import 'package:flutter/material.dart';

class CalendarPageBody extends StatelessWidget {
  const CalendarPageBody({super.key,});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'To do: write calendar page',
            ),
            Text(
              'Calendar',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      );
  }
}