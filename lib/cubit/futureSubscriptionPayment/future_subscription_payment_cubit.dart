import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/daos/customer_dao.dart';
import 'package:jamanacanal/daos/future_subscription_payment_dao.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/future_subscription_payment_detail.dart';

part 'future_subscription_payment_state.dart';

class FutureSubscriptionPaymentCubit
    extends Cubit<FutureSubscriptionPaymentState> {
  final FutureSubscriptionPaymentsDao _futureSubscriptionPaymentsDao;
  final CustomersDao _customersDao;
  final NotificationCubit _notificationCubit;

  FutureSubscriptionPaymentCubit(
    this._futureSubscriptionPaymentsDao,
    this._notificationCubit,
    this._customersDao,
  ) : super(FutureSubscriptionInitial());

  Future<void> load() async {
    final subscriptions = await _futureSubscriptionPaymentsDao.findAllDetails();

    emit(FutureSubscriptionLoaded(subscriptions: subscriptions));
  }

  Future<void> closeFutureSubscription(int subscriptionId) async {
    await _futureSubscriptionPaymentsDao.removeSubscription(subscriptionId);

    load();
  }

  Future<void> addSubscription(int customerId) async {
    try {
      emit(FutureSubscriptionPaymentFormUnderTraintement());

      await _futureSubscriptionPaymentsDao
          .addSubscription(FutureSubscriptionPaymentsCompanion(
        customerId: Value(customerId),
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
    emit(FutureSubscriptionPaymentFormLoaded(customers: customers));
  }
}
