import 'package:flutter/material.dart';
import 'package:jamanacanal/models/customer_detail.dart';
import 'package:jamanacanal/pages/customer/widgets/customer_number_widget.dart';
import 'package:jamanacanal/pages/customer/widgets/phone_number_widget.dart';
import 'package:jamanacanal/widgets/bold_tag.dart';
import 'package:jamanacanal/widgets/customer_full_name.dart';

class CustomerTile extends StatelessWidget {
  const CustomerTile({
    super.key,
    required this.customer,
  });

  final CustomerDetail customer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomerFullName(
            customerFullName: "${customer.firstName} ${customer.lastName}",
          ),
          Row(
            children: [
              PhoneNumberWidget(phoneNumber: customer.phoneNumber),
              const SizedBox(width: 10),
              CustomerNumberWidget(numberCustomer: customer.custumerNumber),
            ],
          ),
          Wrap(
            children: [
              BoldTag(
                color: Colors.blue,
                text:
                    "${customer.numberOfActiveSubscription} abonnement actif (s)",
              ),
              const SizedBox(width: 5),
              BoldTag(
                color: Colors.blue,
                text: "${customer.numberOfDecoder} décodeur (s)",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
