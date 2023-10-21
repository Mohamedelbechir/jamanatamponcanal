import 'package:equatable/equatable.dart';

class CustomerDetail extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? custumerNumber;
  final int numberOfActiveSubscription;
  final int numberOfDecoder;

  const CustomerDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.custumerNumber,
    required this.numberOfActiveSubscription,
    required this.numberOfDecoder,
  });
  bool get hasPhoneNumber => phoneNumber != null && phoneNumber != "";
  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phoneNumber,
        custumerNumber,
        numberOfActiveSubscription,
        numberOfDecoder,
      ];
}
