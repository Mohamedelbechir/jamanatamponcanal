part of 'customer_cubit.dart';

sealed class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

final class CustomerInitial extends CustomerState {}

final class AddingCustomer extends CustomerState {}

final class CustomerAdded extends CustomerState {}

final class CustomerLoaded extends CustomerState {
  final List<CustomerDetail> customers;

  const CustomerLoaded({required this.customers});

  @override
  List<Object> get props => [customers];
}
