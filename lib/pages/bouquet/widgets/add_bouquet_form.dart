import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/model_top.dart';

import '../../../widgets/form_action_buttons.dart';

class AddBouquetForm extends StatefulWidget {
  const AddBouquetForm({super.key});

  @override
  State<AddBouquetForm> createState() => _AddBouquetFormState();
}

class _AddBouquetFormState extends State<AddBouquetForm> {
  final _formKey = GlobalKey<FormState>();

  String bouquetName = "";
  bool isSubmitting = false;
  StreamSubscription<BouquetState>? subscription;

  @override
  void initState() {
    super.initState();
    subscription =
        context.read<BouquetCubit>().stream.listen(listenBouquetCubit);
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  void listenBouquetCubit(state) {
    setState(() {
      if (state is AddingNewBouquet) {
        isSubmitting = true;
      } else {
        isSubmitting = false;
      }
      if (state is BouquetAdded) {
        _formKey.currentState!.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            modalTop,
            const SizedBox(height: 20),
            TextFormField(
              onSaved: (value) => bouquetName = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Merci de saisir le nom du bouquet';
                }
                return null;
              },
              decoration: AppInputDecoration(
                hintText: "Saisir le nom du bouquet",
              ),
            ),
            const SizedBox(height: 20),
            FormActionButtons(isSubmitting: isSubmitting, onSave: handleSave),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Function? handleSave() {
    return isSubmitting
        ? null
        : () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              context.read<BouquetCubit>().addBouquet(bouquetName);
            }
          };
  }
}
