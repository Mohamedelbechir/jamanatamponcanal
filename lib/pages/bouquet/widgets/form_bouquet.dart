import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/models/bouquet_input_data.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/notification_widget.dart';

import '../../../widgets/form_action_buttons.dart';
import '../../../widgets/modal_title.dart';

class FormBouquet extends StatefulWidget {
  const FormBouquet({
    super.key,
    required this.formTitle,
    required this.onSubmit,
  });
  final String formTitle;
  final ValueChanged<BouquetInputData> onSubmit;

  @override
  State<FormBouquet> createState() => _FormBouquetState();
}

class _FormBouquetState extends State<FormBouquet> {
  final _formKey = GlobalKey<FormState>();

  bool isSubmitting = false;
  StreamSubscription<BouquetState>? subscription;
  final _bouquetTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().reset();

    setText(context.read<BouquetCubit>().state);
    subscription =
        context.read<BouquetCubit>().stream.listen(listenBouquetCubit);
  }

  void setText(BouquetState bouquetState) {
    if (bouquetState is BouquetFormLoaded) {
      setState(() {
        _bouquetTextController.text = bouquetState.bouquetInputData.name;
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
      if (state is BouquetFormUnderTraitement) {
        isSubmitting = true;
      } else {
        isSubmitting = false;
      }
    });
    setText(state);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BlocBuilder<BouquetCubit, BouquetState>(
          buildWhen: (prev, next) => next is BouquetFormLoaded,
          builder: (context, state) {
            if (state is BouquetFormLoaded) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ModalTitle(text: widget.formTitle),
                  const Text("Nom bouquet"),
                  TextFormField(
                    controller: _bouquetTextController,
                    onChanged: (value) {
                      context.read<BouquetCubit>().setCurrentFormatData(
                          state.bouquetInputData.copyWith(name: value));
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Merci de saisir le nom du bouquet';
                      }
                      return null;
                    },
                    decoration: AppInputDecoration(),
                  ),
                  const SizedBox(height: 20),
                  const NotificationWidget(),
                  FormActionButtons(
                    isSubmitting: isSubmitting,
                    onSave: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSubmit(state.bouquetInputData);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
