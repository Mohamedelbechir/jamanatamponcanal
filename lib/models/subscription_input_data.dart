import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import 'package:jamanacanal/models/database.dart';

// ignore: must_be_immutable
class SubscriptionInputData extends Equatable {
  int? subcriptionId;
  int? customerId;
  int? bouquetId;
  int? decoderId;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  bool paid = false;

  SubscriptionInputData();

  SubscriptionInputData.init({
    this.subcriptionId,
    required this.customerId,
    required this.bouquetId,
    required this.decoderId,
    required this.startDate,
    required this.endDate,
    required this.paid,
  });

  SubscriptionsCompanion get companion {
    return SubscriptionsCompanion(
      bouquetId: Value(bouquetId!),
      decoderId: Value(decoderId!),
      startDate: Value(startDate),
      endDate: Value(endDate),
      paid: Value(paid),
    );
  }

  @override
  List<Object?> get props => [
        customerId,
        bouquetId,
        decoderId,
        startDate,
        endDate,
        paid,
      ];

  SubscriptionInputData copyWith({
    int? customerId,
    int? bouquetId,
    int? decoderId,
    bool? paid,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SubscriptionInputData.init(
      customerId: customerId ?? this.customerId,
      bouquetId: bouquetId ?? this.bouquetId,
      decoderId: decoderId ?? this.decoderId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      paid: paid ?? this.paid,
    );
  }
}
