import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'widgets/add_customer_form.dart';

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

  showAddCustomerFormDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: modalTopBorderRadius),
      builder: (_) {
        return BlocProvider<CustomerCubit>.value(
          value: context.read(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: AddCustomerForm(),
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
          builder: (context, state) {
            if (state is CustomerLoaded) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
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
        onPressed: showAddCustomerFormDialog,
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
