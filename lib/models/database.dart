import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:jamanacanal/models/customer.dart';
import 'package:jamanacanal/models/decoder.dart';
import 'package:jamanacanal/models/subscription.dart';
import 'package:path_provider/path_provider.dart';
import 'bouquet.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

/*
    dart run build_runner watch
 */

@DriftDatabase(tables: [
  Bouquets,
  Customers,
  Subscriptions,
  Decoders,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    debugPrint(file.path);
    return NativeDatabase.createInBackground(file);
  });
}
