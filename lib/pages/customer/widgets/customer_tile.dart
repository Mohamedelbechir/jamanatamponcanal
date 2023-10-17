import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/models/customer_detail.dart';
import 'package:jamanacanal/pages/customer/widgets/customer_number_widget.dart';
import 'package:jamanacanal/pages/customer/widgets/form_customer.dart';
import 'package:jamanacanal/pages/customer/widgets/phone_number_widget.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/bold_tag.dart';
import 'package:jamanacanal/widgets/customer_full_name.dart';

class CustomerTile extends StatefulWidget {
  const CustomerTile({
    super.key,
    required this.customer,
  });

  final CustomerDetail customer;

  @override
  State<CustomerTile> createState() => _CustomerTileState();
}

class _CustomerTileState extends State<CustomerTile> {
  showCustomerFormDialog() {
    context.read<CustomerCubit>().loadEditingForm(widget.customer.id);

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: modalTopBorderRadius),
      builder: (_) {
        return BlocProvider<CustomerCubit>.value(
          value: context.read(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormCustomer(
              formTitle: "Modifier abonné",
              onSubmit: (customerInputData) {
                context.read<CustomerCubit>().updateCustomer(customerInputData);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showCustomerFormDialog,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomerFullName(
              customerFullName:
                  "${widget.customer.firstName} ${widget.customer.lastName}",
            ),
            Wrap(
              children: [
                PhoneNumberWidget(phoneNumber: widget.customer.phoneNumber),
                const SizedBox(width: 5),
                CustomerNumberWidget(
                  numberCustomer:
                      widget.customer.custumerNumber.split("|").join(" | "),
                ),
              ],
            ),
            Wrap(
              children: [
                BoldTag(
                  color: Colors.blue,
                  text:
                      "${widget.customer.numberOfActiveSubscription} abonnement actif (s)",
                ),
                const SizedBox(width: 5),
                BoldTag(
                  color: Colors.blue,
                  text: "${widget.customer.numberOfDecoder} décodeur (s)",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
