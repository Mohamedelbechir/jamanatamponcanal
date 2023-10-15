import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/model_top.dart';
import '../../../cubit/customer/customer_input_data.dart';
import '../../../widgets/form_action_buttons.dart';

class AddCustomerForm extends StatefulWidget {
  const AddCustomerForm({super.key});

  @override
  State<AddCustomerForm> createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final customerInputData = CustomerInputData();

  bool isSubmitting = false;

  final _formKey = GlobalKey<FormState>();

  StreamSubscription<CustomerState>? subscription;

  final _currentDecoderNumberTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    subscription =
        context.read<CustomerCubit>().stream.listen(listenBouquetCubit);
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  void listenBouquetCubit(state) {
    setState(() {
      if (state is AddingCustomer) {
        isSubmitting = true;
      } else {
        isSubmitting = false;
      }
      if (state is CustomerLoaded) {
        _formKey.currentState!.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .70,
      minChildSize: 0.1,
      builder: (_, controller) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              modalTop,
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Nom"),
                        TextFormField(
                          onSaved: (value) =>
                              customerInputData.lastName = value!,
                          validator: (value) {
                            return emptyNessValidation(
                              value,
                              'Merci de saisir le nom du client',
                            );
                          },
                          decoration: AppInputDecoration(
                            hintText: "Saisir le nom du client",
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text("Prénom"),
                        TextFormField(
                          onSaved: (value) =>
                              customerInputData.firstName = value!,
                          validator: (value) {
                            return emptyNessValidation(
                              value,
                              'Merci de saisir le prénom du client',
                            );
                          },
                          decoration: AppInputDecoration(
                            hintText: "Saisir le prénom du client",
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text("Numéro client"),
                        TextFormField(
                          onSaved: (value) =>
                              customerInputData.numberCustomer = value!,
                          validator: (value) {
                            return emptyNessValidation(
                              value,
                              'Merci de saisir le numéro du client',
                            );
                          },
                          keyboardType: TextInputType.number,
                          decoration: AppInputDecoration(
                            hintText: "Saisir le numéro du client",
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text("Numéro de téléphone"),
                        TextFormField(
                          onSaved: (value) =>
                              customerInputData.phoneNumber = value!,
                          validator: (value) {
                            return emptyNessValidation(
                              value,
                              'Merci de saisir le numéro de téléphone du client',
                            );
                          },
                          keyboardType: TextInputType.number,
                          decoration: AppInputDecoration(
                            hintText: "Saisir le numéro de téléphone du client",
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                            "Décodeurs (saisir un ou plusieurs décodeurs)"),
                        if (customerInputData.decoderNumbers.isNotEmpty)
                          Column(
                            children: [
                              const SizedBox(height: 5),
                              Wrap(
                                children: customerInputData.decoderNumbers
                                    .map(_buildDecoderNumbderItem)
                                    .toList(),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        TextFormField(
                          controller: _currentDecoderNumberTextController,
                          validator: (value) {
                            if (customerInputData.decoderNumbers.isNotEmpty) {
                              return null;
                            }
                            return emptyNessValidation(
                              value,
                              'Merci de saisir le numéro du decodeur',
                            );
                          },
                          keyboardType: TextInputType.number,
                          decoration: AppInputDecoration(
                            hintText: "Saisir le numéro du décodeur",
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  customerInputData.decoderNumbers.add(
                                      _currentDecoderNumberTextController.text);
                                  _currentDecoderNumberTextController.clear();
                                });
                              },
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FormActionButtons(
                          isSubmitting: isSubmitting,
                          onSave: handleSave,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container _buildDecoderNumbderItem(String decoder) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      margin: const EdgeInsets.only(right: 5),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            decoder,
            style: const TextStyle(color: Colors.white),
          ),
          InkWell(
            onTap: () {
              setState(() {
                customerInputData.decoderNumbers.remove(decoder);
              });
            },
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Function? handleSave() {
    return isSubmitting
        ? null
        : () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              context.read<CustomerCubit>().addCustomer(customerInputData);
            }
          };
  }

  String? emptyNessValidation(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }
}
