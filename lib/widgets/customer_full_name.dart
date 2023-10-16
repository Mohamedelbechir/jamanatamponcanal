import 'package:flutter/material.dart';

class CustomerFullName extends StatelessWidget {
  const CustomerFullName({
    super.key,
    required this.customerFullName,
  });

  final String customerFullName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.person, color: Colors.blue[900]),
        const SizedBox(width: 5),
        Text(
          customerFullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
