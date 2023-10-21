// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'subscription_filter_cubit.dart';

sealed class SubscriptionFilterState extends Equatable {
  const SubscriptionFilterState();

  @override
  List<Object?> get props => [];
}

final class SubscriptionFilterInitial extends SubscriptionFilterState {}

final class SubscriptionFilterLoaded extends SubscriptionFilterState {
  final SubscriptionFilterType currentFilter;
  final int? customerId;

  const SubscriptionFilterLoaded({
    this.customerId,
    this.currentFilter = SubscriptionFilterType.active,
  });

  @override
  List<Object?> get props => [currentFilter, customerId];

  SubscriptionFilterLoaded copyWith({
    SubscriptionFilterType? currentFilter,
    Optional<int> customerId = const Optional<int>.empty(),
  }) {
    return SubscriptionFilterLoaded(
      currentFilter: currentFilter ?? this.currentFilter,
      customerId: customerId.isEmpty ? this.customerId : customerId.value,
    );
  }
}
