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

final class AddingNewBouquet extends BouquetState {}

final class BouquetAdded extends BouquetState {}
