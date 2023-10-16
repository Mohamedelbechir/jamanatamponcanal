import 'package:drift/drift.dart';
import 'package:jamanacanal/models/bouquet.dart';
import 'package:jamanacanal/models/database.dart';

part 'bouquet_dao.g.dart';

class BouquetDetail {
  final String id;
  final String name;
  final int nombreOfActiveSubcription;

  BouquetDetail({
    required this.id,
    required this.name,
    required this.nombreOfActiveSubcription,
  });
}

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
            (SELECT COUNT(*) FROM subscriptions s WHERE start_date >= DATE('now') AND end_date >= DATE('now') AND b.id = b.bouquet_id) AS number_of_active_subscription
      FROM bouquets b;

      """,
    ).map((row) {
      return BouquetDetail(
          id: row.read("id"),
          name: row.read("name"),
          nombreOfActiveSubcription:
              row.read<int>("number_of_active_subscription"));
    }).get();
  }

  // returns the generated id
  Future<int> addBouquet(BouquetsCompanion bouquet) {
    return into(bouquets)
        .insert(bouquet.copyWith(createAt: Value(DateTime.now())));
  }

  Future updateBouquet(Bouquet bouquet) {
    return update(bouquets)
        .replace(bouquet.copyWith(updateAt: Value(DateTime.now())));
  }
}
