import 'package:drift/drift.dart';
import 'package:jamanacanal/models/database.dart';

class DataBackupRepository {
  DataBackupRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  Future<Map<String, dynamic>> exportSnapshot() async {
    final customers = await _database.select(_database.customers).get();
    final decoders = await _database.select(_database.decoders).get();
    final bouquets = await _database.select(_database.bouquets).get();
    final subscriptions = await _database.select(_database.subscriptions).get();
    final futurePayments =
        await _database.select(_database.futureSubscriptionPayments).get();

    return {
      'customers': customers.map(_customerToMap).toList(),
      'decoders': decoders.map(_decoderToMap).toList(),
      'bouquets': bouquets.map(_bouquetToMap).toList(),
      'subscriptions': subscriptions.map(_subscriptionToMap).toList(),
      'futureSubscriptionPayments':
          futurePayments.map(_futurePaymentToMap).toList(),
    };
  }

  Future<void> importSnapshot(Map<String, dynamic> data) async {
    await _database.customStatement('PRAGMA foreign_keys = OFF');

    try {
      await _database.transaction(() async {
        await _database.delete(_database.futureSubscriptionPayments).go();
        await _database.delete(_database.subscriptions).go();
        await _database.delete(_database.decoders).go();
        await _database.delete(_database.bouquets).go();
        await _database.delete(_database.customers).go();

        for (final raw in _readList(data, 'customers')) {
          await _database.into(_database.customers).insert(CustomersCompanion(
            id: Value(_readInt(raw, 'id')),
            firstName: Value(_readString(raw, 'firstName')),
            lastName: Value(_readString(raw, 'lastName')),
            phoneNumber: Value(_readNullableString(raw, 'phoneNumber')),
            numberCustomer: Value(_readNullableString(raw, 'numberCustomer')),
          ));
        }

        for (final raw in _readList(data, 'bouquets')) {
          await _database.into(_database.bouquets).insert(BouquetsCompanion(
            id: Value(_readInt(raw, 'id')),
            name: Value(_readString(raw, 'name')),
            obsolete: Value(_readBool(raw, 'obsolete')),
            createAt: Value(_readNullableDateTime(raw, 'createAt')),
            updateAt: Value(_readNullableDateTime(raw, 'updateAt')),
          ));
        }

        for (final raw in _readList(data, 'decoders')) {
          await _database.into(_database.decoders).insert(DecodersCompanion(
            id: Value(_readInt(raw, 'id')),
            number: Value(_readString(raw, 'number')),
            customerId: Value(_readInt(raw, 'customerId')),
          ));
        }

        for (final raw in _readList(data, 'subscriptions')) {
          await _database.into(_database.subscriptions).insert(
                SubscriptionsCompanion(
                  id: Value(_readInt(raw, 'id')),
                  startDate: Value(_readDateTime(raw, 'startDate')),
                  endDate: Value(_readDateTime(raw, 'endDate')),
                  paid: Value(_readBool(raw, 'paid')),
                  bouquetId: Value(_readInt(raw, 'bouquetId')),
                  decoderId: Value(_readInt(raw, 'decoderId')),
                ),
              );
        }

        for (final raw in _readList(data, 'futureSubscriptionPayments')) {
          await _database.into(_database.futureSubscriptionPayments).insert(
                FutureSubscriptionPaymentsCompanion(
                  id: Value(_readInt(raw, 'id')),
                  closed: Value(_readBool(raw, 'closed')),
                  bouquetId: Value(_readNullableInt(raw, 'bouquetId')),
                  customerId: Value(_readInt(raw, 'customerId')),
                ),
              );
        }

        await _resetAutoIncrement('customers');
        await _resetAutoIncrement('decoders');
        await _resetAutoIncrement('bouquets');
        await _resetAutoIncrement('subscriptions');
        await _resetAutoIncrement('future_subscription_payments');
      });
    } finally {
      await _database.customStatement('PRAGMA foreign_keys = ON');
    }
  }

  Future<void> _resetAutoIncrement(String tableName) async {
    await _database.customStatement('''
      UPDATE sqlite_sequence
      SET seq = COALESCE((SELECT MAX(id) FROM $tableName), 0)
      WHERE name = '$tableName'
    ''');
  }

  Map<String, dynamic> _customerToMap(Customer customer) => {
        'id': customer.id,
        'firstName': customer.firstName,
        'lastName': customer.lastName,
        'phoneNumber': customer.phoneNumber,
        'numberCustomer': customer.numberCustomer,
      };

  Map<String, dynamic> _decoderToMap(Decoder decoder) => {
        'id': decoder.id,
        'number': decoder.number,
        'customerId': decoder.customerId,
      };

  Map<String, dynamic> _bouquetToMap(Bouquet bouquet) => {
        'id': bouquet.id,
        'name': bouquet.name,
        'obsolete': bouquet.obsolete,
        'createAt': bouquet.createAt?.millisecondsSinceEpoch,
        'updateAt': bouquet.updateAt?.millisecondsSinceEpoch,
      };

  Map<String, dynamic> _subscriptionToMap(Subscription subscription) => {
        'id': subscription.id,
        'startDate': subscription.startDate.millisecondsSinceEpoch,
        'endDate': subscription.endDate.millisecondsSinceEpoch,
        'paid': subscription.paid,
        'bouquetId': subscription.bouquetId,
        'decoderId': subscription.decoderId,
      };

  Map<String, dynamic> _futurePaymentToMap(
    FutureSubscriptionPayment payment,
  ) =>
      {
        'id': payment.id,
        'closed': payment.closed,
        'bouquetId': payment.bouquetId,
        'customerId': payment.customerId,
      };

  List<Map<String, dynamic>> _readList(
    Map<String, dynamic> data,
    String key,
  ) {
    final value = data[key];
    if (value is! List) return const [];
    return value.whereType<Map>().map(Map<String, dynamic>.from).toList();
  }

  int _readInt(Map<String, dynamic> data, String key) =>
      (data[key] as num).toInt();

  int? _readNullableInt(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) return null;
    return (value as num).toInt();
  }

  String _readString(Map<String, dynamic> data, String key) =>
      data[key] as String;

  String? _readNullableString(Map<String, dynamic> data, String key) =>
      data[key] as String?;

  bool _readBool(Map<String, dynamic> data, String key) => data[key] as bool;

  DateTime _readDateTime(Map<String, dynamic> data, String key) =>
      DateTime.fromMillisecondsSinceEpoch(_readInt(data, key));

  DateTime? _readNullableDateTime(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch((value as num).toInt());
  }
}
