import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/daos/bouquet_dao.dart';
import 'package:jamanacanal/daos/customer_dao.dart';
import 'package:jamanacanal/daos/decoder_dao.dart';
import 'package:jamanacanal/daos/subscription_dao.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/subscription_detail.dart';
import 'package:jamanacanal/notification/notification.dart';

import '../../models/subscription_input_data.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionsDao _subscriptionsDao;
  final DecodersDao _decodersDao;
  final BouquetsDao _bouquetsDao;
  final CustomersDao _customersDao;
  final NotificationCubit _notificationCubit;
  SubscriptionCubit(
    this._subscriptionsDao,
    this._decodersDao,
    this._bouquetsDao,
    this._customersDao,
    this._notificationCubit,
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
      forAdding: true,
    ));
  }

  Future<void> addSubscription(
    SubscriptionInputData subscriptionInputData,
  ) async {
    try {
      emit(AddingSubscription());

      final subscriptionId = await _subscriptionsDao
          .addSubscription(subscriptionInputData.companion);

      await Future.delayed(const Duration(milliseconds: 500));

      emit(SubscriptionAdded());
      final addSubscription =
          await _subscriptionsDao.findSubscriptionDetail(subscriptionId);
      //zonedScheduleNotification(addSubscription!);

      _notificationCubit.push(
        NotificationType.success,
        "Abonnement ajouté avec succès !",
      );

      await loadSubscriptions();
      loadForm();
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

      _notificationCubit.push(
        NotificationType.success,
        "Abonnement ajouté avec succès !",
      );

      await loadSubscriptions();
      loadForm();
    } catch (e) {
      _notificationCubit.push(
        NotificationType.error,
        "Error lors de la mise à jour",
      );
    }
  }
}
