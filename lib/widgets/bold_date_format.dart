import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoldDateFormat extends StatelessWidget {
  const BoldDateFormat({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat.yMMMEd('fr').format(date),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
