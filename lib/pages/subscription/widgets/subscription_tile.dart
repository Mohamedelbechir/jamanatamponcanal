import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/models/subscription_detail.dart';
import 'package:jamanacanal/pages/subscription/widgets/form_subscription.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/utils/confirm_dialog.dart';
import 'package:jamanacanal/widgets/bold_date_format.dart';
import 'package:jamanacanal/widgets/bold_tag.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:jamanacanal/pages/customer/widgets/phone_number_widget.dart';

import '../../../widgets/customer_full_name.dart';

class SubscriptionTile extends StatefulWidget {
  SubscriptionTile({
    super.key,
    required this.subscription,
  }) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  }

  final SubscriptionDetail subscription;

  @override
  State<SubscriptionTile> createState() => _SubscriptionTileState();
}

class _SubscriptionTileState extends State<SubscriptionTile> {
  showSubscriptionFormDialog() async {
    context.read<SubscriptionCubit>().loadEditingForm(widget.subscription.id);

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
              formTitle: "Modifier abonnement",
              onSubmit: (subscriptionInputData) {
                context
                    .read<SubscriptionCubit>()
                    .updateSubscription(subscriptionInputData);
              },
            ),
          ),
        );
      },
    );
  }

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
                title: "Supprimer abonnement",
                message: "Etes-vous sûr de vouloir supprimer cet abonnement ?",
                primaryColor: Colors.red,
                onComfirm: () {
                  context
                      .read<SubscriptionCubit>()
                      .removeSubscription(widget.subscription.id);
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
      child: Stack(
        children: [
          InkWell(
            onTap: showSubscriptionFormDialog,
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
                    child: SelectableText(
                      "N° décodeur. ${widget.subscription.decoderNumber}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                        fontSize: 18,
                      ),
                    ),
                  ),
                  CustomerFullName(
                    customerFullName: widget.subscription.customerFullName,
                  ),
                  if (widget.subscription.hasPhoneNumber)
                    PhoneNumberWidget(
                        phoneNumber: widget.subscription.phoneNumber!),
                  Row(
                    children: [
                      Text(
                        widget.subscription.bouquetName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (widget.subscription.paid)
                        const BoldTag(
                          text: "Abonnment payé",
                          color: Colors.green,
                        )
                      else
                        const BoldTag(
                          text: "Abonnment non payé",
                          color: Colors.red,
                        ),
                    ],
                  ),
                  Wrap(
                    children: [
                      BoldDateFormat(date: widget.subscription.startDate),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "-",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      BoldDateFormat(date: widget.subscription.endDate),
                    ],
                  ),
                  BoldTag(
                    color: Colors.blue,
                    text: "Abonnement prends fin ${timeago.format(
                      widget.subscription.endDate,
                      allowFromNow: true,
                      locale: "fr_short",
                    )}",
                  )
                ],
              ),
            ),
          ),
          if (widget.subscription.hasPayment)
            const Positioned(
              right: 5,
              top: 10,
              child: Icon(
                Icons.attach_money,
                color: Colors.pink,
              ),
            )
        ],
      ),
    );
  }
}
