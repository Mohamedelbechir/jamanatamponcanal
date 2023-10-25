import 'package:drift/drift.dart';
import 'package:jamanacanal/models/bouquet.dart';
import 'package:jamanacanal/models/customer.dart';

class FutureSubscriptionPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get closed => boolean().withDefault(const Constant(false))();
  IntColumn get bouquetId => integer()
      .nullable()
      .references(Bouquets, #id, onDelete: KeyAction.cascade)();
  IntColumn get customerId =>
      integer().references(Customers, #id, onDelete: KeyAction.cascade)();
}
