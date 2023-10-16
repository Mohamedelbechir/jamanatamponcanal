import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'widgets/add_subscription_form.dart';
import 'widgets/subscription_tile.dart';

class AbonnementPage extends StatefulWidget {
  const AbonnementPage({super.key});

  @override
  State<AbonnementPage> createState() => _AbonnementPageState();
}

class _AbonnementPageState extends State<AbonnementPage> {
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
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: AddSubscriptionForm(),
          ),
        );
      },
    ).then((_) {
      context.read<NotificationCubit>().reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoaded) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.subscriptions.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return SubscriptionTile(
                        subscription: state.subscriptions.elementAt(index),
                      );
                    }),
              );
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
