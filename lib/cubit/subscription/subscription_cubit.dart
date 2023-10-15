import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jamanacanal/daos/bouquet_dao.dart';
import 'package:jamanacanal/daos/customer_dao.dart';
import 'package:jamanacanal/daos/decoder_dao.dart';
import 'package:jamanacanal/daos/subscription_dao.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/subscription_detail.dart';

import '../../models/subscription_input_data.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionsDao _subscriptionsDao;
  final DecodersDao _decodersDao;
  final BouquetsDao _bouquetsDao;
  final CustomersDao _customersDao;
  SubscriptionCubit(
    this._subscriptionsDao,
    this._decodersDao,
    this._bouquetsDao,
    this._customersDao,
  ) : super(SubscriptionInitial());

  Future<void> loadSubscriptions() async {
    final subscriptions = await _subscriptionsDao.allSubscriptionDetails();

    emit(SubscriptionLoaded(subscriptions: subscriptions));
  }

  Future<void> loadForm() async {
    emit(SubscriptionFormLoading());

    final bouquets = await _bouquetsDao.allBouquets;
    final decoders = await _decodersDao.allDecoders;
    final customers = await _customersDao.allCustomers;

    emit(SubscriptionFormLoaded(
      bouquets: bouquets,
      decoders: decoders,
      customers: customers,
    ));
  }

  Future<void> addSubscription(
    SubscriptionInputData subscriptionInputData,
  ) async {
    emit(AddingSubscription());

    await _subscriptionsDao.addSubscription(SubscriptionsCompanion(
      bouquetId: Value(subscriptionInputData.bouquetId),
      decoderId: Value(subscriptionInputData.decoderId),
      startDate: Value(subscriptionInputData.startDate),
      endDate: Value(subscriptionInputData.endDate),
      paid: Value(subscriptionInputData.paid),
    ));

    await Future.delayed(const Duration(milliseconds: 500));

    emit(SubscriptionAdded());

    loadSubscriptions();
  }
}
