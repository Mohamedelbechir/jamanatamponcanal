class SubscriptionInputData {
  final int customerId;
  final int bouquetId;
  final int decoderId;
  final DateTime startDate;
  final DateTime endDate;
  final bool paid;

  SubscriptionInputData({
    required this.customerId,
    required this.bouquetId,
    required this.decoderId,
    required this.startDate,
    required this.endDate,
    required this.paid,
  });
}
