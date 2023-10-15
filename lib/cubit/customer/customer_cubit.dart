import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jamanacanal/daos/decoder_dao.dart';
import 'package:jamanacanal/models/customer_detail.dart';
import 'package:jamanacanal/daos/customer_dao.dart';
import 'package:jamanacanal/models/database.dart';

import 'customer_input_data.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomersDao _customersDao;
  final DecodersDao _decodersDao;
  CustomerCubit(this._customersDao, this._decodersDao)
      : super(CustomerInitial());

  Future<void> loadCustomerDetails() async {
    final customerDetails = await _customersDao.allCustomerDetails();
    emit(CustomerLoaded(customers: customerDetails));
  }

  Future<void> addCustomer(CustomerInputData customerInputData) async {
    emit(AddingCustomer());

    final customerId = await _customersDao.addCustomer(CustomersCompanion(
        firstName: Value(customerInputData.firstName),
        lastName: Value(customerInputData.lastName),
        numberCustomer: Value(customerInputData.numberCustomer),
        phoneNumber: Value(customerInputData.phoneNumber)));

    await Future.forEach(customerInputData.decoderNumbers,
        (decoderNumber) async {
      await _decodersDao.addDecoder(DecodersCompanion(
        customerId: Value(customerId),
        number: Value(decoderNumber),
      ));
    });

    await Future.delayed(const Duration(milliseconds: 500));

    emit(CustomerAdded());
    loadCustomerDetails();
  }
}
