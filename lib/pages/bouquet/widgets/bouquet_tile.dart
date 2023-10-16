import 'package:flutter/material.dart';
import 'package:jamanacanal/models/bouquet_detail.dart';
import 'package:jamanacanal/widgets/bold_tag.dart';
import 'package:timeago/timeago.dart' as timeago;

class BouquetTile extends StatelessWidget {
  BouquetTile({
    super.key,
    required this.bouquet,
  }) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  }

  final BouquetDetail bouquet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                bouquet.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              BoldTag(
                color: Colors.blue,
                text:
                    "${bouquet.nombreOfActiveSubcription} abonnement actif (s)",
              ),
            ],
          ),
          if (bouquet.updateAt != null)
            BoldTag(
              color: Colors.blue,
              text: "mise à jour ${timeago.format(
                bouquet.updateAt!,
                locale: "fr",
              )}",
            ),
        ],
      ),
    );
  }
}
