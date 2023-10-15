import 'package:drift/drift.dart';
import 'package:jamanacanal/models/customer.dart';
import 'package:jamanacanal/models/customer_detail.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/decoder.dart';
import 'package:jamanacanal/models/subscription.dart';

part 'customer_dao.g.dart';

@DriftAccessor(tables: [Customers, Subscriptions, Decoders])
class CustomersDao extends DatabaseAccessor<AppDatabase>
    with _$CustomersDaoMixin {
  CustomersDao(AppDatabase appDatabase) : super(appDatabase);

  Future<List<Customer>> get allCustomers => select(customers).get();

  Future<int> addCustomer(CustomersCompanion customer) {
    return into(customers).insert(customer);
  }

  Future<List<CustomerDetail>> allCustomerDetails() {
    return customSelect(
      """
      SELECT id, 
            first_name, 
            last_name, 
            phone_number, 
            number_customer, 
            (SELECT COUNT(*) FROM decoders d WHERE d.customer_id = c.id ) AS number_of_decoder,
            (SELECT COUNT(*) FROM subscriptions s WHERE start_date >= DATE('now') AND end_date >= DATE('now')) AS number_of_active_subscription
      FROM customers c;

      """,
      // used for the stream: the stream will update when either table changes
      readsFrom: {customers, subscriptions, decoders},
    ).map((QueryRow row) {
      return CustomerDetail(
        id: row.read<int>('id'),
        custumerNumber: row.read<String>("number_customer"),
        firstName: row.read<String>("first_name"),
        lastName: row.read<String>("last_name"),
        phoneNumber: row.read<String>("phone_number"),
        numberOfDecoder: row.read<int>("number_of_decoder"),
        numberOfActiveSubscription:
            row.read<int>("number_of_active_subscription"),
      );
    }).get();
  }
}
