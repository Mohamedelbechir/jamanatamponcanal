// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class CustomerInputData extends Equatable {
  int? id;
  String firstName = "";
  String lastName = "";
  String phoneNumber = "";
  Set<String> numberCustomers = {};
  Set<String> decoderNumbers = {};

  CustomerInputData();

  CustomerInputData.init({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.numberCustomers,
    required this.decoderNumbers,
  });

  String get numberCustomer => numberCustomers.join("|");

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phoneNumber,
        numberCustomers,
        decoderNumbers,
      ];

  CustomerInputData copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Set<String>? numberCustomers,
    Set<String>? decoderNumbers,
  }) {
    return CustomerInputData.init(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      numberCustomers: numberCustomers ?? this.numberCustomers,
      decoderNumbers: decoderNumbers ?? this.decoderNumbers,
    );
  }
}
