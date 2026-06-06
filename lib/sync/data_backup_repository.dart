import 'package:drift/drift.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/sync/sync_entity.dart';

class DataBackupRepository {
  DataBackupRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  Future<void> clearAllData() async {
    await _database.customStatement('PRAGMA foreign_keys = OFF');
    try {
      await _database.transaction(() async {
        await _database.delete(_database.futureSubscriptionPayments).go();
        await _database.delete(_database.subscriptions).go();
        await _database.delete(_database.decoders).go();
        await _database.delete(_database.bouquets).go();
        await _database.delete(_database.customers).go();
      });
    } finally {
      await _database.customStatement('PRAGMA foreign_keys = ON');
    }
  }

  Future<Map<SyncCollection, List<Map<String, dynamic>>>> exportAllEntities() async {
    final customers = await _database.select(_database.customers).get();
    final decoders = await _database.select(_database.decoders).get();
    final bouquets = await _database.select(_database.bouquets).get();
    final subscriptions = await _database.select(_database.subscriptions).get();
    final futurePayments =
        await _database.select(_database.futureSubscriptionPayments).get();

    return {
      SyncCollection.customers: customers.map(_customerToMap).toList(),
      SyncCollection.decoders: decoders.map(_decoderToMap).toList(),
      SyncCollection.bouquets: bouquets.map(_bouquetToMap).toList(),
      SyncCollection.subscriptions:
          subscriptions.map(_subscriptionToMap).toList(),
      SyncCollection.futureSubscriptionPayments:
          futurePayments.map(_futurePaymentToMap).toList(),
    };
  }

  Future<Map<String, dynamic>?> exportEntity(
    SyncCollection collection,
    int entityId,
  ) async {
    switch (collection) {
      case SyncCollection.customers:
        final row = await (_database.select(_database.customers)
              ..where((tbl) => tbl.id.equals(entityId)))
            .getSingleOrNull();
        return row == null ? null : _customerToMap(row);
      case SyncCollection.decoders:
        final row = await (_database.select(_database.decoders)
              ..where((tbl) => tbl.id.equals(entityId)))
            .getSingleOrNull();
        return row == null ? null : _decoderToMap(row);
      case SyncCollection.bouquets:
        final row = await (_database.select(_database.bouquets)
              ..where((tbl) => tbl.id.equals(entityId)))
            .getSingleOrNull();
        return row == null ? null : _bouquetToMap(row);
      case SyncCollection.subscriptions:
        final row = await (_database.select(_database.subscriptions)
              ..where((tbl) => tbl.id.equals(entityId)))
            .getSingleOrNull();
        return row == null ? null : _subscriptionToMap(row);
      case SyncCollection.futureSubscriptionPayments:
        final row = await (_database.select(_database.futureSubscriptionPayments)
              ..where((tbl) => tbl.id.equals(entityId)))
            .getSingleOrNull();
        return row == null ? null : _futurePaymentToMap(row);
    }
  }

  Future<void> applyRemoteEntity(
    SyncCollection collection,
    Map<String, dynamic> data,
  ) async {
    if (data['deleted'] == true) {
      await _deleteEntity(collection, _readInt(data, 'id'));
      return;
    }

    switch (collection) {
      case SyncCollection.customers:
        await _database.into(_database.customers).insertOnConflictUpdate(
              CustomersCompanion(
                id: Value(_readInt(data, 'id')),
                firstName: Value(_readString(data, 'firstName')),
                lastName: Value(_readString(data, 'lastName')),
                phoneNumber: Value(_readNullableString(data, 'phoneNumber')),
                numberCustomer:
                    Value(_readNullableString(data, 'numberCustomer')),
              ),
            );
      case SyncCollection.bouquets:
        await _database.into(_database.bouquets).insertOnConflictUpdate(
              BouquetsCompanion(
                id: Value(_readInt(data, 'id')),
                name: Value(_readString(data, 'name')),
                obsolete: Value(_readBool(data, 'obsolete')),
                createAt: Value(_readNullableDateTime(data, 'createAt')),
                updateAt: Value(_readNullableDateTime(data, 'updateAt')),
              ),
            );
      case SyncCollection.decoders:
        await _database.into(_database.decoders).insertOnConflictUpdate(
              DecodersCompanion(
                id: Value(_readInt(data, 'id')),
                number: Value(_readString(data, 'number')),
                customerId: Value(_readInt(data, 'customerId')),
              ),
            );
      case SyncCollection.subscriptions:
        await _database.into(_database.subscriptions).insertOnConflictUpdate(
              SubscriptionsCompanion(
                id: Value(_readInt(data, 'id')),
                startDate: Value(_readDateTime(data, 'startDate')),
                endDate: Value(_readDateTime(data, 'endDate')),
                paid: Value(_readBool(data, 'paid')),
                bouquetId: Value(_readInt(data, 'bouquetId')),
                decoderId: Value(_readInt(data, 'decoderId')),
              ),
            );
      case SyncCollection.futureSubscriptionPayments:
        await _database
            .into(_database.futureSubscriptionPayments)
            .insertOnConflictUpdate(
              FutureSubscriptionPaymentsCompanion(
                id: Value(_readInt(data, 'id')),
                closed: Value(_readBool(data, 'closed')),
                bouquetId: Value(_readNullableInt(data, 'bouquetId')),
                customerId: Value(_readInt(data, 'customerId')),
              ),
            );
    }

    await _resetAutoIncrement(_sqliteTableName(collection));
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

        for (final tableName in const [
          'customers',
          'decoders',
          'bouquets',
          'subscriptions',
          'future_subscription_payments',
        ]) {
          await _resetAutoIncrement(tableName);
        }
      });
    } finally {
      await _database.customStatement('PRAGMA foreign_keys = ON');
    }
  }

  Future<void> _deleteEntity(SyncCollection collection, int entityId) async {
    switch (collection) {
      case SyncCollection.customers:
        await (_database.delete(_database.customers)
              ..where((tbl) => tbl.id.equals(entityId)))
            .go();
      case SyncCollection.decoders:
        await (_database.delete(_database.decoders)
              ..where((tbl) => tbl.id.equals(entityId)))
            .go();
      case SyncCollection.bouquets:
        await (_database.delete(_database.bouquets)
              ..where((tbl) => tbl.id.equals(entityId)))
            .go();
      case SyncCollection.subscriptions:
        await (_database.delete(_database.subscriptions)
              ..where((tbl) => tbl.id.equals(entityId)))
            .go();
      case SyncCollection.futureSubscriptionPayments:
        await (_database.delete(_database.futureSubscriptionPayments)
              ..where((tbl) => tbl.id.equals(entityId)))
            .go();
    }
  }

  String _sqliteTableName(SyncCollection collection) {
    switch (collection) {
      case SyncCollection.futureSubscriptionPayments:
        return 'future_subscription_payments';
      default:
        return syncCollectionName(collection);
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
