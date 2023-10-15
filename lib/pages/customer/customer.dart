import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/tag.dart';
import 'widgets/add_customer_form.dart';

import 'widgets/customer_number_widget.dart';
import 'widgets/phone_number_widget.dart';

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

  showAddBouquetFormDialog() {
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
                  final customer = state.customers.elementAt(index);
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${customer.firstName} ${customer.lastName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            PhoneNumberWidget(
                                phoneNumber: customer.phoneNumber),
                            const SizedBox(width: 10),
                            CustomerNumberWidget(
                                numberCustomer: customer.custumerNumber),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Wrap(
                            children: [
                              /*   _buildTag(
                                    "Fidèle ${timeago.format(DateTime.now(), locale: "fr")}"), */
                              buildTag(
                                  "${customer.numberOfActiveSubscription} abonnement actif"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddBouquetFormDialog,
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
