import 'package:equatable/equatable.dart';

class SubscriptionDetail extends Equatable {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final String bouquetName;
  final String decoderNumber;
  final String phoneNumber;
  final String customerFullName;
  final int customerId;
  final bool paid;

  const SubscriptionDetail({
    required this.id,
    required this.customerId,
    required this.startDate,
    required this.endDate,
    required this.bouquetName,
    required this.phoneNumber,
    required this.decoderNumber,
    required this.customerFullName,
    required this.paid,
  });

  @override
  List<Object?> get props => [
        id,
        customerId,
        startDate,
        endDate,
        bouquetName,
        decoderNumber,
        customerFullName,
        paid,
        phoneNumber,
      ];
}
