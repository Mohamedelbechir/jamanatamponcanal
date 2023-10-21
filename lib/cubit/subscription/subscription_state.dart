// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'subscription_cubit.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

final class SubscriptionInitial extends SubscriptionState {}

final class SubscriptionFormUnderTraitement extends SubscriptionState {}

final class SubscriptionFormTraitementEnded extends SubscriptionState {}

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

  SubscriptionFormLoaded copyWith({
    List<Customer>? customers,
    List<Decoder>? decoders,
    List<Bouquet>? bouquets,
    SubscriptionInputData? subscriptionInputData,
    bool? forAdding,
  }) {
    return SubscriptionFormLoaded(
      customers: customers ?? this.customers,
      decoders: decoders ?? this.decoders,
      bouquets: bouquets ?? this.bouquets,
      subscriptionInputData:
          subscriptionInputData ?? this.subscriptionInputData,
      forAdding: forAdding ?? this.forAdding,
    );
  }
}

final class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionDetail> subscriptions;

  const SubscriptionLoaded({
    required this.subscriptions,
  });
  @override
  List<Object> get props => [subscriptions];
}

final class NoPaidSubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionDetail> subscriptions;
  const NoPaidSubscriptionLoaded({
    required this.subscriptions,
  });
  @override
  List<Object> get props => [subscriptions];
}
