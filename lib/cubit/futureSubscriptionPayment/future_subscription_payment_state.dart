part of 'future_subscription_payment_cubit.dart';

sealed class FutureSubscriptionPaymentState extends Equatable {
  const FutureSubscriptionPaymentState();

  @override
  List<Object?> get props => [];
}

final class FutureSubscriptionInitial extends FutureSubscriptionPaymentState {}

final class FutureSubscriptionPaymentFormUnderTraintement
    extends FutureSubscriptionPaymentState {}

final class FutureSubscriptionPaymentTraintementEnded
    extends FutureSubscriptionPaymentState {}

final class FutureSubscriptionPaymentFormLoaded
    extends FutureSubscriptionPaymentState {
  final List<Customer> customers;

  const FutureSubscriptionPaymentFormLoaded({required this.customers});

  @override
  List<Object?> get props => [customers];
}

final class FutureSubscriptionLoaded extends FutureSubscriptionPaymentState {
  final List<FutureSubscriptionPaymentDetail> subscriptions;

  const FutureSubscriptionLoaded({required this.subscriptions});

  @override
  List<Object?> get props => [subscriptions];
}
