import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/futureSubscriptionPayment/future_subscription_payment_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/widgets/form_action_buttons.dart';
import 'package:jamanacanal/widgets/modal_title.dart';
import 'package:jamanacanal/widgets/notification_widget.dart';

class FormFutureSubscriptionPayment extends StatefulWidget {
  final String formTitle;
  final ValueChanged<int> onSubmit;

  const FormFutureSubscriptionPayment({
    super.key,
    required this.formTitle,
    required this.onSubmit,
  });

  @override
  State<FormFutureSubscriptionPayment> createState() =>
      _FormFutureSubscriptionPaymentState();
}

class _FormFutureSubscriptionPaymentState
    extends State<FormFutureSubscriptionPayment> {
  Customer? selectedCustomer;
  StreamSubscription<FutureSubscriptionPaymentState>? subscription;

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().reset();
    subscription = context
        .read<FutureSubscriptionPaymentCubit>()
        .stream
        .listen(listenCubit);
  }

  void listenCubit(FutureSubscriptionPaymentState state) {
    setState(() {
      _updateSubmittingState(state);

      if (state is FutureSubscriptionPaymentTraintementEnded) {
        setState(() {
          selectedCustomer = null;
        });
      }
    });
  }

  void _updateSubmittingState(state) {
    if (state is FutureSubscriptionPaymentFormUnderTraintement) {
      isSubmitting = true;
    } else {
      isSubmitting = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  bool isSubmitting = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FutureSubscriptionPaymentCubit,
        FutureSubscriptionPaymentState>(
      buildWhen: (prev, next) => next is FutureSubscriptionPaymentFormLoaded,
      builder: (context, state) {
        if (state is FutureSubscriptionPaymentFormLoaded) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModalTitle(text: widget.formTitle),
                const Text("Choisir l'abonné"),
                DropdownSearch<Customer>(
                  enabled: true,
                  items: state.customers,
                  selectedItem: selectedCustomer,
                  clearButtonProps: const ClearButtonProps(isVisible: true),
                  popupProps: const PopupProps.menu(showSearchBox: true),
                  itemAsString: (customer) {
                    return "${customer.firstName} ${customer.lastName}";
                  },
                  onChanged: (customer) {
                    selectedCustomer = customer;
                  },
                ),
                const SizedBox(height: 10),
                const NotificationWidget(),
                FormActionButtons(
                  isSubmitting: isSubmitting,
                  onSave: () {
                    if (selectedCustomer != null) {
                      widget.onSubmit(selectedCustomer!.id);
                    }
                  },
                ),
              ],
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
