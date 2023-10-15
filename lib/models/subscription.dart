import 'package:drift/drift.dart';
import 'package:jamanacanal/models/bouquet.dart';
import 'package:jamanacanal/models/decoder.dart';

class Subscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get paid => boolean().withDefault(const Constant(false))();
  IntColumn get bouquetId => integer().references(Bouquets, #id)();
  IntColumn get decoderId => integer().references(Decoders, #id)();
}
