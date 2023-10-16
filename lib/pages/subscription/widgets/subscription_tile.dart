import 'package:flutter/material.dart';
import 'package:jamanacanal/models/subscription_detail.dart';
import 'package:jamanacanal/widgets/bold_date_format.dart';
import 'package:jamanacanal/widgets/bold_tag.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../widgets/customer_full_name.dart';

class SubscriptionTile extends StatelessWidget {
  SubscriptionTile({
    super.key,
    required this.subscription,
  }) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  }

  final SubscriptionDetail subscription;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SelectableText(
                "N° décodeur. ${subscription.decoderNumber}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  fontSize: 18,
                ),
              ),
            ),
            CustomerFullName(customerFullName: subscription.customerFullName),
            Row(
              children: [
                Text(
                  subscription.bouquetName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                if (subscription.paid)
                  const BoldTag(
                    text: "Abonnment payé",
                    color: Colors.green,
                  )
                else
                  const BoldTag(
                    text: "Abonnment non payé",
                    color: Colors.red,
                  ),
              ],
            ),
            Row(
              children: [
                BoldDateFormat(date: subscription.startDate),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "-",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                BoldDateFormat(date: subscription.endDate),
              ],
            ),
            BoldTag(
              color: Colors.blue,
              text: "Abonnement prends fin ${timeago.format(
                subscription.endDate,
                allowFromNow: true,
                locale: "fr_short",
              )}",
            )
          ],
        ),
      ),
    );
  }
}
