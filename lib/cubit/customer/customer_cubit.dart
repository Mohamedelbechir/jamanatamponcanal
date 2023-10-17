import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
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
  CustomerCubit(
    this._customersDao,
    this._decodersDao,
    this._subscriptionsDao,
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
    final decoders = await _decodersDao.findByCustomer(customerId);

    emit(CustomerFormLoaded(
      forAdding: false,
      customerInputData: CustomerInputData.init(
        id: customer.id,
        firstName: customer.firstName,
        lastName: customer.lastName,
        phoneNumber: customer.phoneNumber,
        numberCustomers: customer.numberCustomer.split("|").toSet(),
        decoderNumbers: decoders.map((decoder) => decoder.number).toSet(),
      ),
    ));
  }

  Future<void> addCustomer(CustomerInputData customerInputData) async {
    emit(AddingCustomer());

    int customerId = await _saveCustomer(customerInputData);

    await _saveDecoders(customerInputData.decoderNumbers, customerId);

    await Future.delayed(const Duration(milliseconds: 500));

    emit(CustomerAdded());

    loadCustomerDetails();
  }

  Future<void> updateCustomer(CustomerInputData customerInputData) async {
    try {
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
          _decodersToRemove(oldDecoders, customerInputData);

      for (var decoderToRemove in decodersToRemove) {
        if (await _canRemoveDecoder(decoderToRemove)) {
          _decodersDao.deleteDecoder(decoderToRemove);
        }
      }
      loadCustomerDetails();
    } catch (e) {}
  }

  Future<bool> _canRemoveDecoder(Decoder decoderToDelete) async {
    final subscription =
        await _subscriptionsDao.findByDecoder(decoderToDelete.id);

    if (subscription == null) {
      return true;
    }
    return false;
  }

  Set<String> _decodersToAdd(
      CustomerInputData customerInputData, List<Decoder> oldDecoders) {
    final decodersToAdd = customerInputData.decoderNumbers.where((formDecoder) {
      return !oldDecoders.map((d) => d.number).contains(formDecoder);
    }).toSet();
    return decodersToAdd;
  }

  List<Decoder> _decodersToRemove(
      List<Decoder> oldDecoders, CustomerInputData customerInputData) {
    final decodersToDelete =
        oldDecoders.fold(<Decoder>[], (collector, oldDecoder) {
      if (!customerInputData.decoderNumbers.contains(oldDecoder.number)) {
        return List.from(collector)..add(oldDecoder);
      }
      return collector;
    });
    return decodersToDelete;
  }

  Future<int> _saveCustomer(CustomerInputData customerInputData) async {
    final customerId = await _customersDao.addCustomer(CustomersCompanion(
        firstName: Value(customerInputData.firstName),
        lastName: Value(customerInputData.lastName),
        numberCustomer: Value(customerInputData.numberCustomer),
        phoneNumber: Value(customerInputData.phoneNumber)));
    return customerId;
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
