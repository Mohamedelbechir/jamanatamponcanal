import 'package:drift/drift.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/future_subscription_payments.dart';

import '../models/future_subscription_payment_detail.dart';

part 'future_subscription_payment_dao.g.dart';

@DriftAccessor(tables: [FutureSubscriptionPayments])
class FutureSubscriptionPaymentsDao extends DatabaseAccessor<AppDatabase>
    with _$FutureSubscriptionPaymentsDaoMixin {
  FutureSubscriptionPaymentsDao(AppDatabase db) : super(db);

  Future<List<FutureSubscriptionPaymentDetail>> findAllDetails() {
    return customSelect("""

            select  f.id,
                    c.first_name || ' ' || c.last_name as customer_full_name,
                    c.phone_number
            from future_subscription_payments f
            inner join customers c on c.id = f.customer_id;

          """).map((row) {
      return FutureSubscriptionPaymentDetail(
        id: row.read<int>("id"),
        customerFullName: row.read<String>("customer_full_name"),
        phoneNumber: row.read<String>("phone_number"),
      );
    }).get();
  }

  Future<FutureSubscriptionPayment> findById(int id) {
    return (select(futureSubscriptionPayments)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<int> addSubscription(
    FutureSubscriptionPaymentsCompanion subscriptionPaymentsCompanion,
  ) {
    return into(futureSubscriptionPayments)
        .insert(subscriptionPaymentsCompanion);
  }

  Future<int> removeSubscription(
    int subscriptionPaymentId,
  ) {
    return (delete(futureSubscriptionPayments)
          ..where((tbl) => tbl.id.equals(subscriptionPaymentId)))
        .go();
  }
}
