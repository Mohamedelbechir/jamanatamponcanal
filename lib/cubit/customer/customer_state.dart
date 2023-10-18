// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'customer_cubit.dart';

sealed class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

final class CustomerInitial extends CustomerState {}

final class CustomerFormUnderTraintement extends CustomerState {}

final class CustomerFormTraitementEnded extends CustomerState {}

final class CustomerFormLoaded extends CustomerState {
  final bool forAdding;
  final CustomerInputData customerInputData;

  const CustomerFormLoaded({
    required this.customerInputData,
    required this.forAdding,
  });

  @override
  List<Object?> get props => [forAdding, customerInputData];

  CustomerFormLoaded copyWith({
    bool? forAdding,
    CustomerInputData? customerInputData,
  }) {
    return CustomerFormLoaded(
      forAdding: forAdding ?? this.forAdding,
      customerInputData: customerInputData ?? this.customerInputData,
    );
  }
}

final class CustomersLoaded extends CustomerState {
  final List<CustomerDetail> customers;

  const CustomersLoaded({required this.customers});

  @override
  List<Object> get props => [customers];
}
