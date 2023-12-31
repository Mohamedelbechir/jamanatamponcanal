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

  Future<List<SubscriptionDetail>> allNoPaidSubscriptionDetails() {
    return customSelect(
      """
      SELECT s.id, 
            s.start_date, 
            s.end_date, 
            s.paid, 
            b.name as bouquet_name,
            d.number AS decoder_number,
            c.phone_number,
            d.customer_id,
            c.first_name || ' ' || c.last_name AS customer_full_name,
            (SELECT COUNT(*) from future_subscription_payments f WHERE f.customer_id = c.id) as "payment_count"
                   
      FROM subscriptions s
      INNER JOIN bouquets b ON b.id = s.bouquet_id
      INNER JOIN decoders d ON d.id = s.decoder_id
      INNER JOIN customers c ON c.id = d.customer_id
      WHERE s.paid = 0
      ORDER BY end_date asc

      """,
    ).map((row) {
      return SubscriptionDetail(
        id: row.read<int>('id'),
        customerId: row.read<int>('customer_id'),
        paid: row.read<bool>("paid"),
        paymentCount: row.read<int>("payment_count"),
        bouquetName: row.read<String>("bouquet_name"),
        phoneNumber: row.read<String>("phone_number"),
        customerFullName: row.read<String>('customer_full_name'),
        decoderNumber: row.read<String>("decoder_number"),
        startDate: row.read<DateTime>("start_date"),
        endDate: row.read<DateTime>("end_date"),
      );
    }).get();
  }

  Future<List<SubscriptionDetail>> allActiveSubscriptionDetails() {
    return customSelect(
      """
      SELECT s.id, 
            s.start_date, 
            s.end_date, 
            s.paid, 
            b.name as bouquet_name,
            d.number AS decoder_number,
            c.phone_number,
            d.customer_id,
            c.first_name || ' ' || c.last_name AS customer_full_name,
            (SELECT COUNT(*) from future_subscription_payments f WHERE f.customer_id = c.id) as "payment_count"
                   
      FROM subscriptions s
      INNER JOIN bouquets b ON b.id = s.bouquet_id
      INNER JOIN decoders d ON d.id = s.decoder_id
      INNER JOIN customers c ON c.id = d.customer_id
      WHERE s.end_date >= strftime('%s', 'now')
      ORDER BY end_date asc

      """,
    ).map((row) {
      return SubscriptionDetail(
        id: row.read<int>('id'),
        customerId: row.read<int>('customer_id'),
        paid: row.read<bool>("paid"),
        paymentCount: row.read<int>("payment_count"),
        bouquetName: row.read<String>("bouquet_name"),
        phoneNumber: row.read<String>("phone_number"),
        customerFullName: row.read<String>('customer_full_name'),
        decoderNumber: row.read<String>("decoder_number"),
        startDate: row.read<DateTime>("start_date"),
        endDate: row.read<DateTime>("end_date"),
      );
    }).get();
  }

  Future<SubscriptionDetail?> findSubscriptionDetail(int subscriptionId) {
    return customSelect(
      """
      SELECT s.id, 
            s.start_date, 
            s.end_date, 
            s.paid, 
            b.name as bouquet_name,
            d.number AS decoder_number,
            c.phone_number,
            d.customer_id,
            c.first_name || ' ' || c.last_name AS customer_full_name,
            (SELECT COUNT(*) from future_subscription_payments f WHERE f.customer_id = c.id) as "payment_count"
                   
      FROM subscriptions s

      INNER JOIN bouquets b ON b.id = s.bouquet_id
      INNER JOIN decoders d ON d.id = s.decoder_id
      INNER JOIN customers c ON c.id = d.customer_id
      WHERE s.id = $subscriptionId

      """,
    ).map((row) {
      return SubscriptionDetail(
        id: row.read<int>('id'),
        customerId: row.read<int>('customer_id'),
        paid: row.read<bool>("paid"),
        paymentCount: row.read<int>("payment_count"),
        bouquetName: row.read<String>("bouquet_name"),
        phoneNumber: row.read<String>("phone_number"),
        customerFullName: row.read<String>('customer_full_name'),
        decoderNumber: row.read<String>("decoder_number"),
        startDate: row.read<DateTime>("start_date"),
        endDate: row.read<DateTime>("end_date"),
      );
    }).getSingleOrNull();
  }

  Future<Subscription?> findByDecoder(int decoderId) {
    return (select(subscriptions)
          ..where((tbl) => tbl.decoderId.equals(decoderId)))
        .getSingleOrNull();
  }

  Future<Subscription> findById(int subscriptionId) {
    return (select(subscriptions)
          ..where((tbl) => tbl.id.equals(subscriptionId)))
        .getSingle();
  }

  Future<bool> updateSubscription(Subscription subscription) {
    return (update(subscriptions).replace(subscription));
  }

  Future<int> remove(int subscriptionId) {
    return (delete(subscriptions)
          ..where((tbl) => tbl.id.equals(subscriptionId)))
        .go();
  }
}
