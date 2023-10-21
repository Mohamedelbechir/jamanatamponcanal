import 'package:drift/drift.dart';
import 'package:jamanacanal/models/bouquet.dart';
import 'package:jamanacanal/models/bouquet_detail.dart';
import 'package:jamanacanal/models/database.dart';

part 'bouquet_dao.g.dart';

@DriftAccessor(tables: [Bouquets])
class BouquetsDao extends DatabaseAccessor<AppDatabase>
    with _$BouquetsDaoMixin {
  BouquetsDao(AppDatabase db) : super(db);

  Future<List<Bouquet>> get allBouquets => select(bouquets).get();
  Future<List<BouquetDetail>> get allBouquetDetails {
    return customSelect(
      """
      SELECT id, 
            name, 
            obsolete, 
            create_at,
            update_at, 
            (SELECT COUNT(*) FROM subscriptions s WHERE s.start_date <=  strftime('%s', 'now') AND s.end_date >= strftime('%s', 'now') AND b.id = s.bouquet_id ) AS number_of_active_subscription
      FROM bouquets b;

      """,
    ).map((row) {
      return BouquetDetail(
          id: row.read("id"),
          name: row.read("name"),
          obsolte: row.read<bool>("obsolete"),
          updateAt: row.read("update_at"),
          nombreOfActiveSubcription:
              row.read<int>("number_of_active_subscription"));
    }).get();
  }

  // returns the generated id
  Future<int> addBouquet(BouquetsCompanion bouquet) {
    return into(bouquets)
        .insert(bouquet.copyWith(createAt: Value(DateTime.now())));
  }

  Future updateBouquetCompanion(BouquetsCompanion bouquet) {
    return update(bouquets)
        .replace(bouquet.copyWith(updateAt: Value(DateTime.now())));
  }

  Future updateBouquet(Bouquet bouquet) {
    return update(bouquets)
        .replace(bouquet.copyWith(updateAt: Value(DateTime.now())));
  }

  Future<Bouquet> findById(int bouquetId) =>
      (select(bouquets)..where((tbl) => tbl.id.equals(bouquetId))).getSingle();
}
