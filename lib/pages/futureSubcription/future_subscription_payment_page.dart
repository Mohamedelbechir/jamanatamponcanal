import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/futureSubscriptionPayment/future_subscription_payment_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/empty_result.dart';

import 'widgets/form_future_subscription_payment.dart';
import 'widgets/future_subscription_payment_tile.dart';

class FutureSubscriptionPaymentPage extends StatefulWidget {
  const FutureSubscriptionPaymentPage({super.key});

  @override
  State<FutureSubscriptionPaymentPage> createState() =>
      _FutureSubscriptionPaymentPageState();
}

class _FutureSubscriptionPaymentPageState
    extends State<FutureSubscriptionPaymentPage> {
  showAddSubscriptionFormDialog() async {
    context.read<FutureSubscriptionPaymentCubit>().loadForm();

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: modalTopBorderRadius),
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<FutureSubscriptionPaymentCubit>.value(
              value: context.read(),
            ),
            BlocProvider<NotificationCubit>.value(value: context.read()),
          ],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormFutureSubscriptionPayment(
              formTitle: "Ajouter payement",
              onSubmit: (formData) {
                context
                    .read<FutureSubscriptionPaymentCubit>()
                    .addSubscription(formData);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BlocBuilder<FutureSubscriptionPaymentCubit,
            FutureSubscriptionPaymentState>(
          buildWhen: (_, next) => next is FutureSubscriptionLoaded,
          builder: (context, state) {
            if (state is FutureSubscriptionLoaded) {
              if (state.subscriptions.isEmpty) {
                return const EmptyResult(text: "Aucun payement disponible");
              }
              return ListView.separated(
                padding: const EdgeInsets.all(10.0),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemCount: state.subscriptions.length,
                itemBuilder: (context, index) {
                  final subscription = state.subscriptions[index];
                  return FutureSubscriptionPaymentTile(
                      subscription: subscription);
                },
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddSubscriptionFormDialog,
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
