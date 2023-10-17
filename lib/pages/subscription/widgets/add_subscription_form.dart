import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/form_action_buttons.dart';
import 'package:jamanacanal/widgets/modal_title.dart';
import '../../../models/subscription_input_data.dart';
import '../../../widgets/notification_widget.dart';

class AddSubscriptionForm extends StatefulWidget {
  const AddSubscriptionForm({Key? key}) : super(key: key);

  @override
  State<AddSubscriptionForm> createState() => _AddSubscriptionFormState();
}

class _AddSubscriptionFormState extends State<AddSubscriptionForm> {
  DateTime _startSelectedDate = DateTime.now();
  DateTime _endSelectedDate = DateTime.now().add(const Duration(days: 30));

  final _startDateTextEditingController = TextEditingController();
  final _endDateTextEditingController = TextEditingController();

  Customer? _selectedCustomer;

  Bouquet? _selectedBouquet;
  Decoder? _selectedDecoder;

  bool isSubmitting = false;
  StreamSubscription<SubscriptionState>? subscription;

  bool _isPaid = false;
  @override
  void initState() {
    super.initState();

    _setDateDisplay(_startSelectedDate, _startDateTextEditingController);
    _setDateDisplay(_endSelectedDate, _endDateTextEditingController);

    _refreshFormValidationState();

    subscription =
        context.read<SubscriptionCubit>().stream.listen(listenBouquetCubit);
  }

  void listenBouquetCubit(state) {
    setState(() {
      if (state is AddingSubscription) {
        isSubmitting = true;
      } else {
        isSubmitting = false;
      }
      if (state is SubscriptionAdded) {
        // abonnement ajouté ajouté avec succès
        //_formKey.currentState!.reset();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  _selectDate({required ValueChanged<DateTime> onSelect}) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _startSelectedDate,
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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ModalTitle(text: "Ajouter abonnement"),
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
                            DropdownButtonFormField<Customer>(
                              decoration: AppInputDecoration(),
                              items: _buildCustomerItemForDropwdown(
                                  state.customers),
                              onChanged: (value) {
                                _selectedCustomer = value;
                                _refreshFormValidationState();
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text('Choisir le bouquet'),
                            DropdownButtonFormField<Bouquet>(
                              decoration: AppInputDecoration(),
                              items:
                                  _buildBouquetItemForDropwdown(state.bouquets),
                              onChanged: (value) {
                                _selectedBouquet = value;
                                _refreshFormValidationState();
                              },
                            ),
                            if (_selectedCustomer != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  const Text('Choisir le numéro du decodeur'),
                                  DropdownButtonFormField<Decoder>(
                                    decoration: AppInputDecoration(),
                                    items: _buildDecoderItemForDropwdown(
                                      state.decodersForCustomer(
                                          _selectedCustomer!.id),
                                    ),
                                    onChanged: (value) {
                                      _selectedDecoder = value;
                                      _refreshFormValidationState();
                                    },
                                  ),
                                ],
                              ),
                            const SizedBox(height: 10),
                            const Text("Choisir la date début de l'abonnement"),
                            const SizedBox(height: 10),
                            TextField(
                              focusNode: AlwaysDisabledFocusNode(),
                              decoration: AppInputDecoration(
                                  iconData: Icons.calendar_month),
                              controller: _startDateTextEditingController,
                              onTap: () {
                                _selectDate(onSelect: (value) {
                                  _startSelectedDate = value;
                                  _setDateDisplay(
                                    value,
                                    _startDateTextEditingController,
                                  );
                                  _refreshFormValidationState();
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
                                _selectDate(onSelect: (value) {
                                  _endSelectedDate = value;
                                  _setDateDisplay(
                                    value,
                                    _endDateTextEditingController,
                                  );
                                  _refreshFormValidationState();
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isPaid = !_isPaid;
                                });
                              },
                              child: Row(
                                children: [
                                  Switch(
                                    value: _isPaid,
                                    onChanged: (bool isPaid) {
                                      setState(() {
                                        _isPaid = isPaid;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Payer"),
                                ],
                              ),
                            ),
                            const NotificationWidget(),
                            FormActionButtons(
                              isSubmitting: isSubmitting,
                              onSave: handleSave,
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
        );
      },
    );
  }

  void _refreshFormValidationState() {
    bool valid = true;
    if (_selectedBouquet == null ||
        _selectedCustomer == null ||
        _selectedDecoder == null) {
      valid = false;
    }
    setState(() {
      _isFormValid = valid;
    });
  }

  bool _isFormValid = false;

  handleSave() {
    if (_isFormValid) {
      _submitFormData();
    }
  }

  void _submitFormData() {
    context.read<SubscriptionCubit>().addSubscription(SubscriptionInputData(
          bouquetId: _selectedBouquet!.id,
          customerId: _selectedCustomer!.id,
          decoderId: _selectedDecoder!.id,
          startDate: _startSelectedDate,
          endDate: _endSelectedDate,
          paid: _isPaid,
        ));
  }

  _buildCustomerItemForDropwdown(List<Customer> decoders) {
    return decoders.map((decoder) {
      return DropdownMenuItem<Customer>(
        value: decoder,
        child: Text("${decoder.firstName} ${decoder.lastName}"),
      );
    }).toList();
  }

  _buildBouquetItemForDropwdown(List<Bouquet> bouquets) {
    return bouquets.map((bouquet) {
      return DropdownMenuItem<Bouquet>(
        value: bouquet,
        child: Text(bouquet.name),
      );
    }).toList();
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
