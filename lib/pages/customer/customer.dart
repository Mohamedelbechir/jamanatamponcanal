import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/empty_result.dart';
import 'widgets/form_customer.dart';

import 'widgets/customer_tile.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerCubit>().loadCustomerDetails();
  }

  showCustomerFormDialog() {
    context.read<CustomerCubit>().loadForm();

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: modalTopBorderRadius),
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<CustomerCubit>.value(
              value: context.read(),
            ),
            BlocProvider<NotificationCubit>.value(
              value: context.read(),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormCustomer(
              formTitle: "Ajouter abonné",
              onSubmit: (customerInputData) {
                context.read<CustomerCubit>().addCustomer(customerInputData);
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
        child: BlocBuilder<CustomerCubit, CustomerState>(
          buildWhen: (prev, next) => next is CustomersLoaded,
          builder: (context, state) {
            if (state is CustomersLoaded) {
              if (state.customers.isEmpty) {
                return const EmptyResult(text: "Aucun abonné disponible");
              }
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10.0),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemCount: state.customers.length,
                itemBuilder: (_, index) {
                  return CustomerTile(
                    customer: state.customers.elementAt(index),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCustomerFormDialog,
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
