import 'package:equatable/equatable.dart';

class FutureSubscriptionPaymentDetail extends Equatable {
  final int id;
  final String customerFullName;
  final String bouquetName;
  final String? phoneNumber;

  const FutureSubscriptionPaymentDetail({
    required this.id,
    required this.customerFullName,
    required this.phoneNumber,
    required this.bouquetName,
  });

  @override
  List<Object?> get props => [
        id,
        customerFullName,
        phoneNumber,
      ];

  bool get hasPhoneNumber => phoneNumber != null && phoneNumber != "";
}
