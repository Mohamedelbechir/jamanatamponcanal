import 'package:flutter/material.dart';

Future<dynamic> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  MaterialColor primaryColor = Colors.red,
  required VoidCallback onComfirm,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            onPressed: () {
              onComfirm();
              Navigator.of(context).pop();
            },
            child: const Text(
              "Supprimer",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}
