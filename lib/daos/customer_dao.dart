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
      SELECT c.id, 
             first_name, 
             last_name, 
             phone_number, 
             number_customer, 
             count(d.id) as number_of_decoder,
             (SELECT COUNT(*) 
              FROM subscriptions s 
              WHERE  s.decoder_id = d.id 
                    AND start_date <= strftime('%s', 'now') 
                    AND end_date >= strftime('%s', 'now')) 
                    AS number_of_active_subscription

      FROM customers c
      LEFT JOIN decoders d on d.customer_id = c.id
      GROUP BY c.id;

      """,
      // used for the stream: the stream will update when either table changes
    ).map((QueryRow row) {
      return CustomerDetail(
        id: row.read<int>('id'),
        custumerNumber: row.read("number_customer"),
        firstName: row.read("first_name"),
        lastName: row.read("last_name"),
        phoneNumber: row.read("phone_number"),
        numberOfDecoder: row.read("number_of_decoder"),
        numberOfActiveSubscription: row.read("number_of_active_subscription"),
      );
    }).get();
  }

  Future<Customer> findById(int customerId) {
    return (select(customers)..where((t) => t.id.equals(customerId)))
        .getSingle();
  }

  Future<bool> updateCustomer(Customer customer) {
    return update(customers).replace(customer);
  }
}
