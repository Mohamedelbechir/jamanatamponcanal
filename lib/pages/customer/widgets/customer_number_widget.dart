import 'package:flutter/material.dart';

class CustomerNumberWidget extends StatelessWidget {
  const CustomerNumberWidget({
    super.key,
    required this.numberCustomer,
  });

  final String numberCustomer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.numbers),
        Text(
          numberCustomer,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
