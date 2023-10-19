import 'package:drift/drift.dart';
import 'package:jamanacanal/models/customer.dart';

class Decoders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get number => text()();
  IntColumn get customerId =>
      integer().references(Customers, #id, onDelete: KeyAction.cascade)();
}
