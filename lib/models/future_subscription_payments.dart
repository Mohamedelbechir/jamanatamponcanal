import 'package:drift/drift.dart';
import 'package:jamanacanal/models/customer.dart';

class FutureSubscriptionPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get closed => boolean().withDefault(const Constant(false))();
  IntColumn get customerId =>
      integer().references(Customers, #id, onDelete: KeyAction.cascade)();
}
