import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/cubit/customer/customer_input_data.dart';
import 'package:jamanacanal/utils/utils_values.dart';

class FormFirstName extends StatelessWidget {
  const FormFirstName({
    super.key,
    required TextEditingController controller,
    required this.customerInputData,
  }) : _firstNameTextController = controller;

  final TextEditingController _firstNameTextController;
  final CustomerInputData customerInputData;

  @override
  Widget build(BuildContext context) {
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
            if (value == null || value.isEmpty) {
              return 'Merci de saisir le prénom du client';
            }
            return null;
          },
          decoration: AppInputDecoration(),
        ),
      ],
    );
  }
}
