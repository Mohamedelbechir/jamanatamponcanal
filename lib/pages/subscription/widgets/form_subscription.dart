import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/utils/functions.dart';
import 'package:jamanacanal/widgets/form_action_buttons.dart';
import 'package:jamanacanal/widgets/modal_title.dart';
import '../../../models/subscription_input_data.dart';
import '../../../widgets/notification_widget.dart';
import 'subscription_paid_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';

class FormSubscription extends StatefulWidget {
  const FormSubscription({
    Key? key,
    required this.onSubmit,
    required this.formTitle,
  }) : super(key: key);
  final ValueChanged<SubscriptionInputData> onSubmit;
  final String formTitle;

  @override
  State<FormSubscription> createState() => _FormSubscriptionState();
}

class _FormSubscriptionState extends State<FormSubscription> {
  final _startDateTextEditingController = TextEditingController();
  final _endDateTextEditingController = TextEditingController();

  bool isSubmitting = false;
  StreamSubscription<SubscriptionState>? subscription;

  @override
  void initState() {
    super.initState();

    context.read<NotificationCubit>().reset();

    final currentState = context.read<SubscriptionCubit>().state;
    if (currentState is SubscriptionFormLoaded) {
      _setDatesDisplay(currentState.subscriptionInputData);
      _refreshFormValidationState(currentState.subscriptionInputData);
    }

    subscription = context
        .read<SubscriptionCubit>()
        .stream
        .listen(listenSubscriptionCubit);
  }

  void listenSubscriptionCubit(state) {
    setState(() {
      if (state is SubscriptionFormUnderTraitement) {
        isSubmitting = true;
      } else {
        isSubmitting = false;
      }
      if (state is SubscriptionFormLoaded) {
        _setDatesDisplay(state.subscriptionInputData);
        _refreshFormValidationState(state.subscriptionInputData);
      }
    });
  }

  void _setDatesDisplay(SubscriptionInputData subscriptionInputData) {
    _setDateDisplay(
      subscriptionInputData.startDate,
      _startDateTextEditingController,
    );
    _setDateDisplay(
      subscriptionInputData.endDate,
      _endDateTextEditingController,
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  _selectDate({
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelect,
  }) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2040));
    if (newSelectedDate != null) onSelect(newSelectedDate);
  }

  _setDateDisplay(
    DateTime? date,
    TextEditingController textEditingController,
  ) {
    if (date != null) {
      textEditingController
        ..text = DateFormat.MMMEd('fr').format(date)
        ..selection = TextSelection.fromPosition(TextPosition(
          offset: textEditingController.text.length,
          affinity: TextAffinity.upstream,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .75,
      minChildSize: 0.1,
      builder: (context, controller) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModalTitle(text: widget.formTitle),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                      buildWhen: (prev, next) => next is SubscriptionFormLoaded,
                      builder: (context, state) {
                        if (state is SubscriptionFormLoaded) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Choisir l'abonné"),
                              DropdownSearch<Customer>(
                                items: state.customers,
                                popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                ),
                                enabled: true,
                                itemAsString: (customer) {
                                  return "${customer.firstName} ${customer.lastName}";
                                },
                                validator: (items) {
                                  if (items == null) {
                                    return "Merci de choisir l'abonné";
                                  }
                                  return null;
                                },
                                selectedItem: state.customer(
                                  state.subscriptionInputData.customerId,
                                ),
                                onChanged: (value) {
                                  context
                                      .read<SubscriptionCubit>()
                                      .setCurrentFormData(state
                                          .subscriptionInputData
                                          .copyWith(customerId: value?.id));
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text('Choisir le bouquet'),
                              DropdownButtonFormField<Bouquet>(
                                value: state.bouquet(
                                  state.subscriptionInputData.bouquetId,
                                ),
                                decoration: AppInputDecoration(),
                                items: buildBouquetItemForDropwdown(
                                    state.bouquets),
                                onChanged: (value) {
                                  context
                                      .read<SubscriptionCubit>()
                                      .setCurrentFormData(state
                                          .subscriptionInputData
                                          .copyWith(bouquetId: value?.id));
                                  _refreshFormValidationState(
                                      state.subscriptionInputData);
                                },
                              ),
                              if (state.subscriptionInputData.customerId !=
                                  null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text('Choisir le numéro du decodeur'),
                                    DropdownButtonFormField<Decoder>(
                                      decoration: AppInputDecoration(),
                                      value: state.decoder(state
                                          .subscriptionInputData.decoderId),
                                      items: _buildDecoderItemForDropwdown(
                                        state.decodersForCustomer(state
                                            .subscriptionInputData.customerId!),
                                      ),
                                      onChanged: (value) {
                                        context
                                            .read<SubscriptionCubit>()
                                            .setCurrentFormData(state
                                                .subscriptionInputData
                                                .copyWith(
                                                    decoderId: value!.id));
                                      },
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 10),
                              const Text(
                                  "Choisir la date début de l'abonnement"),
                              const SizedBox(height: 10),
                              TextField(
                                focusNode: AlwaysDisabledFocusNode(),
                                decoration: AppInputDecoration(
                                    iconData: Icons.calendar_month),
                                controller: _startDateTextEditingController,
                                onTap: () {
                                  _selectDate(
                                      initialDate:
                                          state.subscriptionInputData.startDate,
                                      onSelect: (value) {
                                        context
                                            .read<SubscriptionCubit>()
                                            .setCurrentFormData(state
                                                .subscriptionInputData
                                                .copyWith(startDate: value));

                                        _setDateDisplay(
                                          value,
                                          _startDateTextEditingController,
                                        );
                                      });
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text("Choisir la date fin de l'abonnement"),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _endDateTextEditingController,
                                focusNode: AlwaysDisabledFocusNode(),
                                decoration: AppInputDecoration(
                                  iconData: Icons.calendar_month,
                                ),
                                onTap: () {
                                  _selectDate(
                                      initialDate:
                                          state.subscriptionInputData.endDate,
                                      onSelect: (value) {
                                        context
                                            .read<SubscriptionCubit>()
                                            .setCurrentFormData(state
                                                .subscriptionInputData
                                                .copyWith(endDate: value));

                                        _setDateDisplay(
                                          value,
                                          _endDateTextEditingController,
                                        );
                                      });
                                },
                              ),
                              const SizedBox(height: 10),
                              SubscriptionPaidWidget(
                                subscriptionInputData:
                                    state.subscriptionInputData,
                              ),
                              const NotificationWidget(),
                              FormActionButtons(
                                isSubmitting: isSubmitting,
                                onSave: () {
                                  handleSave(state.subscriptionInputData);
                                },
                              ),
                            ],
                          );
                        }

                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _refreshFormValidationState(
    SubscriptionInputData subscriptionInputData,
  ) {
    bool valid = true;
    if (subscriptionInputData.bouquetId == null ||
        subscriptionInputData.customerId == null ||
        subscriptionInputData.decoderId == null) {
      valid = false;
    }
    setState(() {
      _isFormValid = valid;
    });
  }

  bool _isFormValid = false;

  handleSave(SubscriptionInputData subscriptionInputData) {
    if (_isFormValid) {
      widget.onSubmit(subscriptionInputData);
    }
  }

  _buildDecoderItemForDropwdown(List<Decoder> decoders) {
    return decoders.map((decoder) {
      return DropdownMenuItem<Decoder>(
        value: decoder,
        child: Text(decoder.number),
      );
    }).toList();
  }
}
