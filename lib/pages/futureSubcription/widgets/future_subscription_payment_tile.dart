import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jamanacanal/cubit/futureSubscriptionPayment/future_subscription_payment_cubit.dart';
import 'package:jamanacanal/models/future_subscription_payment_detail.dart';
import 'package:jamanacanal/pages/customer/widgets/phone_number_widget.dart';
import 'package:jamanacanal/utils/confirm_dialog.dart';
import 'package:jamanacanal/widgets/customer_full_name.dart';

class FutureSubscriptionPaymentTile extends StatelessWidget {
  const FutureSubscriptionPaymentTile({
    super.key,
    required this.subscription,
  });

  final FutureSubscriptionPaymentDetail subscription;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (_) {
              confirmDialog(
                context,
                title: "Supprimer payement",
                message: "Etes-vous sûr de vouloir supprimer cet payement ?",
                onComfirm: () {
                  context
                      .read<FutureSubscriptionPaymentCubit>()
                      .closeFutureSubscription(subscription.id);
                },
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Supprimer',
          ),
        ],
      ),
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  subscription.bouquetName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    fontSize: 18,
                  ),
                ),
              ),
              CustomerFullName(
                customerFullName: subscription.customerFullName,
              ),
              if (subscription.hasPhoneNumber)
                PhoneNumberWidget(phoneNumber: subscription.phoneNumber!),
            ],
          ),
        ),
      ),
    );
  }
}
