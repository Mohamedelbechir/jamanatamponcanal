import 'package:drift/drift.dart';
import 'package:jamanacanal/cubit/customer/customer_input_data.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/decoder.dart';

part 'decoder_dao.g.dart';

@DriftAccessor(tables: [Decoders])
class DecodersDao extends DatabaseAccessor<AppDatabase>
    with _$DecodersDaoMixin {
  DecodersDao(AppDatabase db) : super(db);

  Future<List<Decoder>> get allDecoders => select(decoders).get();

  Future<int> addDecoder(DecodersCompanion decoder) {
    return into(decoders).insert(decoder);
  }

  Future<List<Decoder>> findByCustomer(int customerId) {
    return (select(decoders)..where((tbl) => tbl.customerId.equals(customerId)))
        .get();
  }

  Future<List<DecoderDetail>> findDecodeurDetailsByCustomer(int customerId) {
    return customSelect("""
      select  id,
              number, 
              (select count(*) from subscriptions s where s.decoder_id = d.id) as subscription_count

              from decoders d
              where customer_id = $customerId;
    """).map((row) {
      return DecoderDetail(
          number: row.read("number"),
          id: row.read<int>("id"),
          numberOfSubscription: row.read<int>("subscription_count"));
    }).get();
  }

  Future<int> deleteDecoder(Decoder decoderToDelete) {
    return delete(decoders).delete(decoderToDelete);
  }
}
