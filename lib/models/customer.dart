import 'package:drift/drift.dart';

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get numberCustomer => text().nullable()();
}
