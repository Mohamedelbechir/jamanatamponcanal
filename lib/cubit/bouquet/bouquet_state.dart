// ignore_for_file: public_member_api_docs, sort_constructors_first
part of './bouquet_cubit.dart';

@immutable
sealed class BouquetState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class BouquetInitial extends BouquetState {}

final class BouquetLoaded extends BouquetState {
  final List<BouquetDetail> bouquets;

  BouquetLoaded({required this.bouquets});

  @override
  List<Object?> get props => [bouquets];
}

class BouquetFormLoaded extends BouquetState {
  final bool forAdding;
  final BouquetInputData bouquetInputData;

  BouquetFormLoaded({
    this.forAdding = true,
    required this.bouquetInputData,
  });

  BouquetFormLoaded copyWith({
    bool? forAdding,
    BouquetInputData? bouquetInputData,
  }) {
    return BouquetFormLoaded(
      forAdding: forAdding ?? this.forAdding,
      bouquetInputData: bouquetInputData ?? this.bouquetInputData,
    );
  }

  @override
  List<Object?> get props => [
        forAdding,
        bouquetInputData,
      ];
}

final class BouquetFormUnderTraitement extends BouquetState {}

final class BouquetFormTraitementEnded extends BouquetState {}
