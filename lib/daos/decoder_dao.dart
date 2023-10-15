import 'package:drift/drift.dart';
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
}
