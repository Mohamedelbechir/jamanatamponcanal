import 'package:drift/drift.dart';
import 'package:jamanacanal/models/bouquet.dart';
import 'package:jamanacanal/models/customer.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/decoder.dart';
import 'package:jamanacanal/models/subscription.dart';
import 'package:jamanacanal/models/subscription_detail.dart';

part 'subscription_dao.g.dart';

@DriftAccessor(tables: [
  Subscriptions,
  Decoders,
  Bouquets,
  Customers,
])
class SubscriptionsDao extends DatabaseAccessor<AppDatabase>
    with _$SubscriptionsDaoMixin {
  SubscriptionsDao(AppDatabase db) : super(db);

  Future<int> addSubscription(SubscriptionsCompanion subscriptionsCompanion) {
    return into(subscriptions).insert(subscriptionsCompanion);
  }

  Future<List<SubscriptionDetail>> allSubscriptionDetails() {
    return customSelect(
      """
      SELECT s.id, 
            s.start_date, 
            s.end_date, 
            s.paid, 
            b.name as bouquet_name,
            d.number AS decoder_number,
            c.first_name || ' ' || c.last_name AS customer_full_name
                   
      FROM subscriptions s
      INNER JOIN bouquets b ON b.id = s.bouquet_id
      INNER JOIN decoders d ON d.id = s.decoder_id
      INNER JOIN customers c ON c.id = d.customer_id

      """,
      // used for the stream: the stream will update when either table changes
      // readsFrom: {customers, subscriptions, decoders, bouquets},
    ).map((row) {
      return SubscriptionDetail(
        id: row.read<int>('id'),
        paid: row.read<bool>("paid"),
        bouquetName: row.read<String>("bouquet_name"),
        customerFullName: row.read<String>('customer_full_name'),
        decoderNumber: row.read<String>("decoder_number"),
        startDate: row.read<DateTime>("start_date"),
        endDate: row.read<DateTime>("end_date"),
      );
    }).get();
  }
}
