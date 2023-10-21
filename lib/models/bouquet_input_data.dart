// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class BouquetInputData extends Equatable {
  int? id;
  String name = "";
  bool obsolete = false;

  BouquetInputData();

  BouquetInputData.init({
    required this.id,
    required this.name,
    required this.obsolete,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        obsolete,
      ];

  BouquetInputData copyWith({
    int? id,
    String? name,
    bool? obsolete,
  }) {
    return BouquetInputData.init(
      id: id ?? this.id,
      name: name ?? this.name,
      obsolete: obsolete ?? this.obsolete,
    );
  }
}
