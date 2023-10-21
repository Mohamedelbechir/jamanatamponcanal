// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'bouquetName': bouquetName,
      'decoderNumber': decoderNumber,
      'phoneNumber': phoneNumber,
      'customerFullName': customerFullName,
      'customerId': customerId,
      'paid': paid,
    };
  }

  factory SubscriptionDetail.fromMap(Map<String, dynamic> map) {
    return SubscriptionDetail(
      id: map['id'] as int,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      bouquetName: map['bouquetName'] as String,
      decoderNumber: map['decoderNumber'] as String,
      phoneNumber: map['phoneNumber'] as String,
      customerFullName: map['customerFullName'] as String,
      customerId: map['customerId'] as int,
      paid: map['paid'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionDetail.fromJson(String source) =>
      SubscriptionDetail.fromMap(json.decode(source) as Map<String, dynamic>);
}
