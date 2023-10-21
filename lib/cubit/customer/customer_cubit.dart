import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/daos/decoder_dao.dart';
import 'package:jamanacanal/models/customer_detail.dart';
import 'package:jamanacanal/daos/customer_dao.dart';
import 'package:jamanacanal/models/database.dart';

import 'customer_input_data.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomersDao _customersDao;
  final DecodersDao _decodersDao;
  final NotificationCubit _notificationCubit;
  final SubscriptionCubit _subscriptionCubit;
  final BouquetCubit _bouquetCubit;

  CustomerCubit(
    this._customersDao,
    this._decodersDao,
    this._subscriptionCubit,
    this._bouquetCubit,
    this._notificationCubit,
  ) : super(CustomerInitial());

  Future<void> loadCustomerDetails() async {
    final customers = await _customersDao.allCustomerDetails();
    emit(CustomersLoaded(customers: customers));
  }

  void loadForm() {
    emit(CustomerFormLoaded(
      customerInputData: CustomerInputData(),
      forAdding: true,
    ));
  }

  Future<void> loadEditingForm(int customerId) async {
    final customer = await _customersDao.findById(customerId);
    final decoders =
        await _decodersDao.findDecodeurDetailsByCustomer(customerId);

    emit(CustomerFormLoaded(
      forAdding: false,
      customerInputData: CustomerInputData.init(
        id: customer.id,
        firstName: customer.firstName,
        lastName: customer.lastName,
        phoneNumber: customer.phoneNumber,
        numberCustomers: _getCustomerNumbers(customer),
        decoderDetails: decoders.toSet(),
      ),
    ));
  }

  Set<String> _getCustomerNumbers(Customer customer) {
    if (customer.numberCustomer == null || customer.numberCustomer == "") {
      return {};
    }

    return customer.numberCustomer!.split("|").toSet();
  }

  Future<void> addCustomer(CustomerInputData customerInputData) async {
    try {
      emit(CustomerFormUnderTraintement());

      int customerId = await _saveCustomer(customerInputData);

      await _saveDecoders(
        customerInputData.decoderNumbers,
        customerId,
      );

      await Future.delayed(const Duration(milliseconds: 500));
      _notificationCubit.push(
        NotificationType.success,
        "Abonnée ajouté avec succès !",
      );
      emit(CustomerFormTraitementEnded());
      await loadCustomerDetails();
      loadForm();
    } catch (e) {
      _notificationCubit.push(
        NotificationType.error,
        "Erreur lors de l'ajout",
      );
    }
  }

  Future<void> updateCustomer(CustomerInputData customerInputData) async {
    try {
      emit(CustomerFormUnderTraintement());

      final customer = Customer(
        id: customerInputData.id!,
        firstName: customerInputData.firstName,
        lastName: customerInputData.lastName,
        phoneNumber: customerInputData.phoneNumber,
        numberCustomer: customerInputData.numberCustomer,
      );

      await _customersDao.updateCustomer(customer);
      final oldDecoders =
          await _decodersDao.findByCustomer(customerInputData.id!);

      final decodersToAdd = _decodersToAdd(customerInputData, oldDecoders);

      await _saveDecoders(decodersToAdd, customerInputData.id!);

      final decodersToRemove =
          _decodersToRemove(oldDecoders, customerInputData.decoderNumbers);

      for (var decoderToRemove in decodersToRemove) {
        await _decodersDao.deleteDecoder(decoderToRemove);
      }

      await Future.delayed(const Duration(milliseconds: 500));

      _notificationCubit.push(
        NotificationType.success,
        "Info. mise à jour avec succès !",
      );
      emit(CustomerFormTraitementEnded());

      await loadCustomerDetails();
      loadEditingForm(customerInputData.id!);
    } catch (e) {
      _notificationCubit.push(
        NotificationType.error,
        "Error lors de la mise à jour des informations",
      );
    }
  }

  Set<String> _decodersToAdd(
    CustomerInputData customerInputData,
    List<Decoder> oldDecoders,
  ) {
    return customerInputData.decoderNumbers.where((formDecoder) {
      return !oldDecoders.map((d) => d.number).contains(formDecoder);
    }).toSet();
  }

  List<Decoder> _decodersToRemove(
    List<Decoder> oldDecoders,
    Set<String> decodersFromForm,
  ) {
    return oldDecoders.fold(<Decoder>[], (decodersToRemove, oldDecoder) {
      if (!decodersFromForm.contains(oldDecoder.number)) {
        return List.from(decodersToRemove)..add(oldDecoder);
      }
      return decodersToRemove;
    });
  }

  Future<int> _saveCustomer(CustomerInputData customerInputData) async {
    return await _customersDao.addCustomer(CustomersCompanion(
      firstName: Value(customerInputData.firstName),
      lastName: Value(customerInputData.lastName),
      numberCustomer: Value(customerInputData.numberCustomer),
      phoneNumber: Value(customerInputData.phoneNumber),
    ));
  }

  Future<void> _saveDecoders(
    Set<String> decoders,
    int customerId,
  ) async {
    await Future.forEach(decoders, (decoderNumber) async {
      await _decodersDao.addDecoder(DecodersCompanion(
        customerId: Value(customerId),
        number: Value(decoderNumber),
      ));
    });
  }

  void setCurrentFormData(CustomerInputData customerInputData) {
    final currentState = state as CustomerFormLoaded;

    emit(currentState.copyWith(customerInputData: customerInputData));
  }

  void remove(int customerId) async {
    await _customersDao.removeCustomer(customerId);
    loadCustomerDetails();
    _subscriptionCubit.refreshSubscription();
    _bouquetCubit.load();
  }
}
