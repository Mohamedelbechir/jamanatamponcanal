import 'package:drift/drift.dart';
import 'package:jamanacanal/models/bouquet.dart';
import 'package:jamanacanal/models/database.dart';

part 'bouquet_dao.g.dart';

@DriftAccessor(tables: [Bouquets])
class BouquetsDao extends DatabaseAccessor<AppDatabase>
    with _$BouquetsDaoMixin {
  BouquetsDao(AppDatabase db) : super(db);

  Future<List<Bouquet>> get allBouquets => select(bouquets).get();

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
