import 'package:flutter/material.dart';

class DayCard extends StatelessWidget {
  final String date;
  final String day;

  DayCard(this.date, this.day);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
            textScaler: const TextScaler.linear(1.0),
          ),
          Text(
            day,
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(1.0),
          ),
        ],
      ),
    );
  }
}
