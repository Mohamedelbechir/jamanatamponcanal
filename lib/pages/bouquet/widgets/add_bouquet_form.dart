import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';

import '../../../widgets/form_action_buttons.dart';
import '../../../widgets/modal_title.dart';

class AddBouquetForm extends StatefulWidget {
  const AddBouquetForm({super.key});

  @override
  State<AddBouquetForm> createState() => _AddBouquetFormState();
}

class _AddBouquetFormState extends State<AddBouquetForm> {
  final _formKey = GlobalKey<FormState>();

  String bouquetName = "";
  bool isSubmitting = false;
  bool isFormValid = false;
  StreamSubscription<BouquetState>? subscription;
  final _bouquetTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    subscription =
        context.read<BouquetCubit>().stream.listen(listenBouquetCubit);

    _bouquetTextController.addListener(_listenBouquetTextChange);
  }

  void _listenBouquetTextChange() {
    final currentText = _bouquetTextController.text.trim();

    if (currentText.isNotEmpty && !isFormValid) {
      setState(() {
        isFormValid = true;
      });
    }
    if (currentText.isEmpty && isFormValid) {
      setState(() {
        isFormValid = false;
      });
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ModalTitle(text: "Ajouter bouquet"),
            const Text("Nom bouquet"),
            TextFormField(
              controller: _bouquetTextController,
              onSaved: (value) => bouquetName = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Merci de saisir le nom du bouquet';
                }
                return null;
              },
              decoration: AppInputDecoration(),
            ),
            const SizedBox(height: 20),
            FormActionButtons(
              isSubmitting: isSubmitting,
              onSave: handleSave,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  handleSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<BouquetCubit>().addBouquet(bouquetName);
    }
  }
}
