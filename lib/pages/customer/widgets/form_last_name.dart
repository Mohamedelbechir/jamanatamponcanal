import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/cubit/customer/customer_input_data.dart';
import 'package:jamanacanal/utils/utils_values.dart';

class FormLastName extends StatelessWidget {
  const FormLastName({
    super.key,
    required TextEditingController controller,
    required this.customerInputData,
  }) : _lastNameTextController = controller;

  final TextEditingController _lastNameTextController;
  final CustomerInputData customerInputData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nom"),
        TextFormField(
          controller: _lastNameTextController,
          onChanged: (val) {
            context
                .read<CustomerCubit>()
                .setCurrentFormData(customerInputData.copyWith(
                  lastName: _lastNameTextController.text,
                ));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Merci de saisir le nom du client';
            }
            return null;
          },
          decoration: AppInputDecoration(),
        ),
      ],
    );
  }
}
