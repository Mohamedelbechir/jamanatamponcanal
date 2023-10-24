import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/cubit/subcriptionFilter/subscription_filter_cubit.dart';
import 'package:jamanacanal/daos/bouquet_dao.dart';
import 'package:jamanacanal/daos/customer_dao.dart';
import 'package:jamanacanal/daos/decoder_dao.dart';
import 'package:jamanacanal/daos/subscription_dao.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/subscription_detail.dart';
import 'package:jamanacanal/notification/notification.dart';
import 'package:jamanacanal/utils/functions.dart';

import '../../models/subscription_input_data.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionsDao _subscriptionsDao;
  final DecodersDao _decodersDao;
  final BouquetsDao _bouquetsDao;
  final CustomersDao _customersDao;
  final SubscriptionFilterCubit _subscriptionFilterCubit;
  final NotificationCubit _notificationCubit;
  StreamSubscription<SubscriptionFilterState>? _filterSubscription;
  SubscriptionCubit(
    this._subscriptionsDao,
    this._decodersDao,
    this._bouquetsDao,
    this._customersDao,
    this._notificationCubit,
    this._subscriptionFilterCubit,
  ) : super(SubscriptionInitial()) {
    _listenFilterChange(_subscriptionFilterCubit.state);
    _filterSubscription =
        _subscriptionFilterCubit.stream.listen(_listenFilterChange);
  }

  Future<void> _listenFilterChange(SubscriptionFilterState event) async {
    if (event is SubscriptionFilterLoaded) {
      if (event.currentFilter == SubscriptionFilterType.active) {
        await _loadActiveSubscriptions(event.customerId);
      } else {
        await _loadNoPaidSubscriptions(event.customerId);
      }
    }
  }

  Future<void> loadSubscriptions() => refreshSubscription();

  Future<void> refreshSubscription() async {
    await _listenFilterChange(_subscriptionFilterCubit.state);
  }

  Future<void> removeSubscription(int subscriptionId) async {
    await _subscriptionsDao.remove(subscriptionId);

    safeTry(() async {
      await removeNotification(subscriptionId);
    });

    refreshSubscription();
  }

  Future<void> _loadNoPaidSubscriptions(int? customerId) async {
    final subscriptions =
        await _subscriptionsDao.allNoPaidSubscriptionDetails();
    emit(NoPaidSubscriptionLoaded(
      subscriptions: subscriptions.where((subscription) {
        return customerId == null || subscription.customerId == customerId;
      }).toList(),
    ));
  }

  Future<void> _loadActiveSubscriptions(int? customerId) async {
    final subscriptions =
        await _subscriptionsDao.allActiveSubscriptionDetails();
    emit(SubscriptionLoaded(
      subscriptions: subscriptions.where((subscription) {
        return customerId == null || subscription.customerId == customerId;
      }).toList(),
    ));
  }

  Future<void> loadAddingForm() async {
    emit(SubscriptionFormLoading());

    final bouquets = await _bouquetsDao.allBouquets;
    final decoders = await _decodersDao.allDecoders;
    final customers = await _customersDao.allCustomers;

    emit(SubscriptionFormLoaded(
      bouquets: bouquets.where((bouquet) => !bouquet.obsolete).toList(),
      decoders: decoders,
      customers: customers,
      subscriptionInputData: SubscriptionInputData(),
      forAdding: true,
    ));
  }

  Future<void> loadEditingForm(int subscriptionId) async {
    final bouquets = await _bouquetsDao.allBouquets;

    final subscription = await _subscriptionsDao.findById(subscriptionId);
    final decoder = await _decodersDao.findById(subscription.decoderId);
    final customer = await _customersDao.findById(decoder.customerId);

    emit(SubscriptionFormLoaded(
      bouquets: bouquets,
      decoders: [decoder],
      customers: [customer],
      subscriptionInputData: SubscriptionInputData.init(
        subcriptionId: subscription.id,
        bouquetId: subscription.bouquetId,
        customerId: decoder.customerId,
        decoderId: decoder.id,
        startDate: subscription.startDate,
        endDate: subscription.endDate,
        paid: subscription.paid,
      ),
      forAdding: false,
    ));
  }

  Future<void> addSubscription(
    SubscriptionInputData subscriptionInputData,
  ) async {
    try {
      emit(SubscriptionFormUnderTraitement());

      final subscriptionId = await _subscriptionsDao
          .addSubscription(subscriptionInputData.companion);

      await Future.delayed(const Duration(milliseconds: 500));

      emit(SubscriptionFormTraitementEnded());

      final addSubscription =
          await _subscriptionsDao.findSubscriptionDetail(subscriptionId);
      safeTry(() {
        zonedScheduleNotification(addSubscription!);
      });

      _notificationCubit.push(
        NotificationType.success,
        "Abonnement ajouté avec succès !",
      );

      await loadSubscriptions();
      loadAddingForm();
    } catch (e) {
      _notificationCubit.push(
        NotificationType.error,
        "Error lors de l'ajout de l'abonnement !",
      );
    }
  }

  Future<void> updateSubscription(
    SubscriptionInputData subscriptionInputData,
  ) async {
    try {
      emit(SubscriptionFormUnderTraitement());

      final subscription = await _subscriptionsDao.findById(
        subscriptionInputData.subcriptionId!,
      );
      final newSubscription = subscription.copyWith(
        bouquetId: subscriptionInputData.bouquetId,
        decoderId: subscriptionInputData.decoderId,
        paid: subscriptionInputData.paid,
        startDate: subscriptionInputData.startDate,
        endDate: subscriptionInputData.endDate,
      );

      await _subscriptionsDao.updateSubscription(newSubscription);

      await Future.delayed(const Duration(milliseconds: 500));
      emit(SubscriptionFormTraitementEnded());

      final addSubscription =
          await _subscriptionsDao.findSubscriptionDetail(subscription.id);
      safeTry(() {
        zonedScheduleNotification(addSubscription!);
      });

      _notificationCubit.push(
        NotificationType.success,
        "Info. mis à jour avec succès !",
      );

      await refreshSubscription();
      loadEditingForm(subscriptionInputData.subcriptionId!);
    } catch (e) {
      _notificationCubit.push(
        NotificationType.error,
        "Error lors de la mise à jour",
      );
      emit(SubscriptionFormTraitementEnded());
    }
  }

  void setCurrentFormData(SubscriptionInputData subscriptionInputData) {
    final currentState = state as SubscriptionFormLoaded;
    emit(currentState.copyWith(subscriptionInputData: subscriptionInputData));
  }

  @override
  Future<void> close() {
    _filterSubscription?.cancel();
    return super.close();
  }
}
