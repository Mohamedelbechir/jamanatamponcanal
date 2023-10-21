import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/optional.dart';

part 'subscription_filter_state.dart';

enum SubscriptionFilterType { active, noPaid }

class SubscriptionFilterCubit extends Cubit<SubscriptionFilterState> {
  SubscriptionFilterCubit() : super(SubscriptionFilterInitial());

  void setCurrentFilter(SubscriptionFilterType subscriptionFilter) {
    final currentState = state;
    if (currentState is SubscriptionFilterLoaded) {
      emit(currentState.copyWith(currentFilter: subscriptionFilter));
    } else {
      emit(SubscriptionFilterLoaded(currentFilter: subscriptionFilter));
    }
  }

  void setCustomer(int? customerId) {
    final currentState = state;
    if (currentState is SubscriptionFilterLoaded) {
      emit(currentState.copyWith(customerId: Optional.value(customerId)));
    } else {
      emit(SubscriptionFilterLoaded(customerId: customerId));
    }
  }
}
