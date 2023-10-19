import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'widgets/form_subscription.dart';
import 'widgets/subscription_tile.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionCubit>().loadSubscriptions();
  }

  showAddSubscriptionFormDialog() async {
    context.read<SubscriptionCubit>().loadForm();

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: modalTopBorderRadius),
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<SubscriptionCubit>.value(value: context.read()),
            BlocProvider<NotificationCubit>.value(value: context.read()),
          ],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormSubscription(
              formTitle: "Ajouter abonnement",
              onSubmit: (subscriptionInputData) {
                context
                    .read<SubscriptionCubit>()
                    .addSubscription(subscriptionInputData);
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
      body: Center(
        child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          buildWhen: (prev, next) => next is SubscriptionLoaded,
          builder: (context, state) {
            if (state is SubscriptionLoaded) {
              return ListView.separated(
                  padding: const EdgeInsets.all(10.0),
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemCount: state.subscriptions.length,
                  itemBuilder: (context, index) {
                    return SubscriptionTile(
                      subscription: state.subscriptions.elementAt(index),
                    );
                  });
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      backgroundColor: Colors.white,
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
