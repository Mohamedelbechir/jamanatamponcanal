part of 'subscription_cubit.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

final class SubscriptionInitial extends SubscriptionState {}

final class AddingSubscription extends SubscriptionState {}

final class SubscriptionAdded extends SubscriptionState {}

final class SubscriptionFormLoading extends SubscriptionState {}

final class SubscriptionFormLoaded extends SubscriptionState {
  final List<Customer> customers;
  final List<Decoder> decoders;
  final List<Bouquet> bouquets;
  final SubscriptionInputData subscriptionInputData;
  final bool forAdding;

  const SubscriptionFormLoaded({
    required this.customers,
    required this.decoders,
    required this.bouquets,
    required this.subscriptionInputData,
    required this.forAdding,
  });

  Decoder? decoder(int? decoderId) {
    return decoders.where((decoder) => decoder.id == decoderId).firstOrNull;
  }

  Customer? customer(int? customerId) {
    return customers.where((customer) => customer.id == customerId).firstOrNull;
  }

  Bouquet? bouquet(int? bouquetId) {
    return bouquets.where((bouquet) => bouquet.id == bouquetId).firstOrNull;
  }

  List<Decoder> decodersForCustomer(int customerId) {
    return decoders
        .where((decoder) => decoder.customerId == customerId)
        .toList();
  }

  @override
  List<Object> get props => [
        customers,
        decoders,
        bouquets,
        forAdding,
        subscriptionInputData,
      ];
}

final class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionDetail> subscriptions;

  const SubscriptionLoaded({required this.subscriptions});
  @override
  List<Object> get props => [subscriptions];
}
