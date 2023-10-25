import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:jamanacanal/models/customer.dart';
import 'package:jamanacanal/models/future_subscription_payments.dart';
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
  FutureSubscriptionPayments,
  Decoders,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        // disable foreign_keys before migrations
        await customStatement('PRAGMA foreign_keys = OFF');

        await transaction(() async {
          await _from1To2(from, m);
          await _from2To3(from, m);
        });

        // Assert that the schema is valid after migrations
        if (kDebugMode) {
          final wrongForeignKeys =
              await customSelect('PRAGMA foreign_key_check').get();
          assert(wrongForeignKeys.isEmpty,
              '${wrongForeignKeys.map((e) => e.data)}');
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _from1To2(int from, Migrator m) async {
    if (from < 2) {
      await m.createTable(futureSubscriptionPayments);
    }
  }

  Future<void> _from2To3(int from, Migrator m) async {
    if (from < 3) {
      await futureSubscriptionPayments.deleteAll();
      await m.addColumn(
        futureSubscriptionPayments,
        futureSubscriptionPayments.bouquetId,
      );
    }
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
