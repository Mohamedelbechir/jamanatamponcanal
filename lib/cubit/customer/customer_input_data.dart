// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class DecoderDetail extends Equatable {
  final int? id;
  final String number;
  final bool readOnly;
  final int numberOfSubscription;

  const DecoderDetail({
    this.id,
    required this.number,
    this.numberOfSubscription = 0,
  }) : readOnly = numberOfSubscription > 0;

  @override
  List<Object?> get props => [
        number,
        readOnly,
      ];
}

// ignore: must_be_immutable
class CustomerInputData extends Equatable {
  int? id;
  String firstName = "";
  String lastName = "";
  String phoneNumber = "";
  Set<String> numberCustomers = {};
  Set<DecoderDetail> decoderDetails = {};
  Set<String> get decoderNumbers => decoderDetails.map((e) => e.number).toSet();

  CustomerInputData();

  CustomerInputData.init({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.numberCustomers,
    required this.decoderDetails,
  });

  String get numberCustomer => numberCustomers.join("|");

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phoneNumber,
        numberCustomers,
        decoderDetails,
      ];

  CustomerInputData copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Set<String>? numberCustomers,
    Set<DecoderDetail>? decoderNumbers,
  }) {
    return CustomerInputData.init(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      numberCustomers: numberCustomers ?? this.numberCustomers,
      decoderDetails: decoderNumbers ?? this.decoderDetails,
    );
  }
}
