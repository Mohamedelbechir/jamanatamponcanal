import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/pages/customer/widgets/removable_tag.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/modal_title.dart';
import 'package:jamanacanal/widgets/notification_widget.dart';
import '../../../cubit/customer/customer_input_data.dart';
import '../../../widgets/form_action_buttons.dart';
import 'form_first_name.dart';
import 'form_last_name.dart';

class FormCustomer extends StatefulWidget {
  const FormCustomer(
      {super.key, required this.onSubmit, required this.formTitle});
  final ValueChanged<CustomerInputData> onSubmit;
  final String formTitle;

  @override
  State<FormCustomer> createState() => _FormCustomerState();
}

class _FormCustomerState extends State<FormCustomer> {
  bool isSubmitting = false;
  bool isValidForm = false;

  final _formKey = GlobalKey<FormState>();

  StreamSubscription<CustomerState>? subscription;

  final _currentDecoderNumberTextController = TextEditingController();
  final _currentCustomerNumberTextController = TextEditingController();

  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();

  late final List<TextEditingController> textControllers;

  @override
  void initState() {
    super.initState();

    _updateTextController(context.read<CustomerCubit>().state);
    subscription =
        context.read<CustomerCubit>().stream.listen(listenBouquetCubit);
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  void listenBouquetCubit(CustomerState state) {
    _updateTextController(state);

    setState(() {
      _updateSubmittingState(state);

      if (state is CustomerFormTraitementEnded) {
        setState(() {
          _formKey.currentState!.reset();
        });
      }
    });
  }

  void _updateTextController(CustomerState state) {
    if (state is CustomerFormLoaded) {
      final customerInputData = state.customerInputData;
      setState(() {
        _lastNameTextController.text = customerInputData.lastName;
        _firstNameTextController.text = customerInputData.firstName;
        _phoneNumberTextController.text = customerInputData.phoneNumber;
      });
    }
  }

  void _updateSubmittingState(state) {
    if (state is CustomerFormUnderTraintement) {
      isSubmitting = true;
    } else {
      isSubmitting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .70,
      minChildSize: 0.1,
      builder: (_, controller) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: BlocBuilder<CustomerCubit, CustomerState>(
              buildWhen: (prev, next) => next is CustomerFormLoaded,
              builder: (context, state) {
                if (state is CustomerFormLoaded) {
                  var customerInputData = state.customerInputData;

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ModalTitle(text: widget.formTitle),
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              controller: controller,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FormLastName(
                                    controller: _lastNameTextController,
                                    customerInputData: customerInputData,
                                  ),
                                  const SizedBox(height: 10),
                                  FormFirstName(
                                    controller: _firstNameTextController,
                                    customerInputData: customerInputData,
                                  ),
                                  const SizedBox(height: 10),
                                  _buildCustomerNumber(state.customerInputData),
                                  const SizedBox(height: 10),
                                  _buildPhoneNumber(state.customerInputData),
                                  const SizedBox(height: 10),
                                  _buildDecoder(state.customerInputData),
                                  const SizedBox(height: 10),
                                  const NotificationWidget(),
                                  FormActionButtons(
                                    isSubmitting: isSubmitting,
                                    onSave: () {
                                      handleSave(state.customerInputData);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        );
      },
    );
  }

  Column _buildDecoder(CustomerInputData customerInputData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Décodeurs (saisir un ou plusieurs décodeurs)"),
        if (customerInputData.decoderDetails.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 5),
              Wrap(
                children: customerInputData.decoderDetails.map((decoder) {
                  return _buildRemovableTagForDecoder(
                    decoder,
                    customerInputData,
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        TextFormField(
          controller: _currentDecoderNumberTextController,
          validator: (value) {
            var message = 'Merci de saisir le numéro du decodeur';
            if (customerInputData.decoderDetails.isEmpty) {
              return message;
            }
            if (customerInputData.decoderDetails.isNotEmpty) {
              return null;
            }
            return emptyNessValidation(value, message);
          },
          keyboardType: TextInputType.number,
          decoration: AppInputDecoration(
            suffixIcon: InkWell(
              onTap: () {
                final newCustomerInputData = customerInputData.copyWith(
                    decoderNumbers: Set<DecoderDetail>.from(
                        customerInputData.decoderDetails)
                      ..add(DecoderDetail(
                        number: _currentDecoderNumberTextController.text,
                      )));
                context
                    .read<CustomerCubit>()
                    .setCurrentFormData(newCustomerInputData);

                _currentDecoderNumberTextController.clear();
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildPhoneNumber(CustomerInputData customerInputData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Numéro de téléphone"),
        TextFormField(
          controller: _phoneNumberTextController,
          onChanged: (value) {
            context
                .read<CustomerCubit>()
                .setCurrentFormData(customerInputData.copyWith(
                  phoneNumber: value,
                ));
          },
          validator: (value) {
            return emptyNessValidation(
              value,
              'Merci de saisir le numéro de téléphone du client',
            );
          },
          keyboardType: TextInputType.number,
          decoration: AppInputDecoration(),
        ),
      ],
    );
  }

  Column _buildCustomerNumber(CustomerInputData customerInputData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Numéro client (saisir un ou plusieurs)"),
        if (customerInputData.numberCustomers.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 5),
              Wrap(
                children:
                    customerInputData.numberCustomers.map((customerNumber) {
                  return _buildRemovableTagForCustomerNumber(
                      customerNumber, customerInputData);
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        TextFormField(
          controller: _currentCustomerNumberTextController,
          validator: (value) {
            var message = 'Merci de saisir le numéro du client';
            if (customerInputData.numberCustomers.isEmpty) {
              return message;
            }
            if (customerInputData.numberCustomers.isNotEmpty) {
              return null;
            }
            return emptyNessValidation(value, message);
          },
          keyboardType: TextInputType.number,
          decoration: AppInputDecoration(
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  var newCustomerInputData = customerInputData.copyWith(
                      numberCustomers: Set<String>.from(
                    customerInputData.numberCustomers,
                  )..add(_currentCustomerNumberTextController.text));

                  context
                      .read<CustomerCubit>()
                      .setCurrentFormData(newCustomerInputData);

                  _currentCustomerNumberTextController.clear();
                });
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildFirstName(CustomerInputData customerInputData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Prénom"),
        TextFormField(
          controller: _firstNameTextController,
          onChanged: (value) {
            context
                .read<CustomerCubit>()
                .setCurrentFormData(customerInputData.copyWith(
                  firstName: value,
                ));
          },
          validator: (value) {
            return emptyNessValidation(
              value,
              'Merci de saisir le prénom du client',
            );
          },
          decoration: AppInputDecoration(),
        ),
      ],
    );
  }

  RemovableTag _buildRemovableTagForDecoder(
      DecoderDetail decoder, CustomerInputData customerInputData) {
    return RemovableTag(
      text: decoder.number,
      readOnly: decoder.readOnly,
      onTapRemove: () {
        final newCustomerInputData = customerInputData.copyWith(
            decoderNumbers: customerInputData.decoderDetails
                .where((item) => item != decoder)
                .toSet());

        context.read<CustomerCubit>().setCurrentFormData(newCustomerInputData);
      },
    );
  }

  RemovableTag _buildRemovableTagForCustomerNumber(
      String customerNumber, CustomerInputData customerInputData) {
    return RemovableTag(
      text: customerNumber,
      onTapRemove: () {
        setState(() {
          var newCustomerInputData = customerInputData.copyWith(
              numberCustomers: customerInputData.numberCustomers
                  .where((item) => item != customerNumber)
                  .toSet());
          context
              .read<CustomerCubit>()
              .setCurrentFormData(newCustomerInputData);
        });
      },
    );
  }

  handleSave(CustomerInputData currentForData) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.onSubmit(currentForData.copyWith(
        firstName: _firstNameTextController.text,
        lastName: _lastNameTextController.text,
        phoneNumber: _phoneNumberTextController.text,
      ));
    }
  }

  String? emptyNessValidation(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }
}
