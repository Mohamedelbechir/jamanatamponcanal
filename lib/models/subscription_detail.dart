import 'package:equatable/equatable.dart';

class SubscriptionDetail extends Equatable {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final String bouquetName;
  final String decoderNumber;
  final String customerFullName;
  final bool paid;

  const SubscriptionDetail({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.bouquetName,
    required this.decoderNumber,
    required this.customerFullName,
    required this.paid,
  });

  @override
  List<Object?> get props => [
        id,
        startDate,
        endDate,
        bouquetName,
        decoderNumber,
        customerFullName,
        paid,
      ];
}
