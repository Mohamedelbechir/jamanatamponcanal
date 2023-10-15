import 'package:drift/drift.dart';

class Bouquets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get obsolete => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createAt => dateTime().nullable()();
  DateTimeColumn get updateAt => dateTime().nullable()();
}
