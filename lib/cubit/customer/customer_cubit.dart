import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/daos/decoder_dao.dart';
import 'package:jamanacanal/daos/subscription_dao.dart';
import 'package:jamanacanal/models/customer_detail.dart';
import 'package:jamanacanal/daos/customer_dao.dart';
import 'package:jamanacanal/models/database.dart';

import 'customer_input_data.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomersDao _customersDao;
  final DecodersDao _decodersDao;
  final SubscriptionsDao _subscriptionsDao;
  final NotificationCubit _notificationCubit;
  CustomerCubit(
    this._customersDao,
    this._decodersDao,
    this._subscriptionsDao,
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
        numberCustomers: customer.numberCustomer.split("|").toSet(),
        decoderDetails: decoders.toSet(),
      ),
    ));
  }

  Future<void> addCustomer(CustomerInputData customerInputData) async {
    emit(CustomerFormUnderTraintement());

    int customerId = await _saveCustomer(customerInputData);

    await _saveDecoders(
      customerInputData.decoderNumbers,
      customerId,
    );

    await Future.delayed(const Duration(milliseconds: 500));

    emit(CustomerFormTraitementEnded());

    loadCustomerDetails();
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
        if (await _canRemoveDecoder(decoderToRemove)) {
          _decodersDao.deleteDecoder(decoderToRemove);
        }
      }

      await Future.delayed(const Duration(milliseconds: 500));

      _notificationCubit.push(
        NotificationType.success,
        "Info. mise à jour avec succès !",
      );
      emit(CustomerFormTraitementEnded());

      loadCustomerDetails();
    } catch (e) {
      _notificationCubit.push(
        NotificationType.error,
        "Error lors de la mise à jour des informations",
      );
    }
  }

  Future<bool> _canRemoveDecoder(Decoder decoderToDelete) async {
    return await _subscriptionsDao.findByDecoder(decoderToDelete.id) == null;
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
    Set<String> decodersFromFrom,
  ) {
    return oldDecoders.fold(<Decoder>[], (collector, oldDecoder) {
      if (!decodersFromFrom.contains(oldDecoder.number)) {
        return List.from(collector)..add(oldDecoder);
      }
      return collector;
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
}
