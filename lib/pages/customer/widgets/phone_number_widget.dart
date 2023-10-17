import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneNumberWidget extends StatelessWidget {
  const PhoneNumberWidget({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse('tel:$phoneNumber')),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.phone,
            color: Colors.blue[900],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              phoneNumber,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
