import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/daos/bouquet_dao.dart';
import 'package:jamanacanal/daos/customer_dao.dart';
import 'package:jamanacanal/daos/future_subscription_payment_dao.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/future_subscription_payment_detail.dart';
import 'package:jamanacanal/models/future_subscription_payment_input_data.dart';

part 'future_subscription_payment_state.dart';

class FutureSubscriptionPaymentCubit
    extends Cubit<FutureSubscriptionPaymentState> {
  final FutureSubscriptionPaymentsDao _futureSubscriptionPaymentsDao;
  final CustomersDao _customersDao;
  final BouquetsDao _bouquetsDao;
  final NotificationCubit _notificationCubit;

  FutureSubscriptionPaymentCubit(
    this._futureSubscriptionPaymentsDao,
    this._notificationCubit,
    this._customersDao,
    this._bouquetsDao,
  ) : super(FutureSubscriptionInitial());

  Future<void> load() async {
    final subscriptions = await _futureSubscriptionPaymentsDao.findAllDetails();

    emit(FutureSubscriptionLoaded(subscriptions: subscriptions));
  }

  Future<void> closeFutureSubscription(int subscriptionId) async {
    await _futureSubscriptionPaymentsDao.removeSubscription(subscriptionId);

    load();
  }

  Future<void> addSubscription(
    FutureSubscriptionPaymentInputData formInputData,
  ) async {
    try {
      emit(FutureSubscriptionPaymentFormUnderTraintement());

      await _futureSubscriptionPaymentsDao
          .addSubscription(FutureSubscriptionPaymentsCompanion(
        customerId: Value(formInputData.customerId),
        bouquetId: Value(formInputData.bouquetId),
      ));

      emit(FutureSubscriptionPaymentTraintementEnded());
      _notificationCubit.push(
        NotificationType.success,
        "Ajouter avec succès !",
      );
      load();
    } catch (e) {
      _notificationCubit.push(
        NotificationType.error,
        "Erreur lors de l'ajout",
      );
    }
  }

  Future<void> loadForm() async {
    final customers = await _customersDao.allCustomers;
    final bouquets = await _bouquetsDao.allBouquets;

    emit(FutureSubscriptionPaymentFormLoaded(
      customers: customers,
      bouquets: bouquets,
    ));
  }
}
