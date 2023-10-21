import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/models/subscription_input_data.dart';

class SubscriptionPaidWidget extends StatelessWidget {
  const SubscriptionPaidWidget({
    super.key,
    required this.subscriptionInputData,
  });
  final SubscriptionInputData subscriptionInputData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<SubscriptionCubit>()
            .setCurrentFormData(subscriptionInputData.copyWith(
              paid: !subscriptionInputData.paid,
            ));
      },
      child: Row(
        children: [
          Switch(
            value: subscriptionInputData.paid,
            onChanged: (bool isPaid) {
              context.read<SubscriptionCubit>().setCurrentFormData(
                  subscriptionInputData.copyWith(paid: isPaid));
            },
          ),
          const SizedBox(width: 10),
          const Text("Payer"),
        ],
      ),
    );
  }
}
