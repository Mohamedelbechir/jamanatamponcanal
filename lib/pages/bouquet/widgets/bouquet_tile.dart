import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/models/bouquet_detail.dart';
import 'package:jamanacanal/pages/bouquet/widgets/form_bouquet.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/bold_tag.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class BouquetTile extends StatefulWidget {
  BouquetTile({
    super.key,
    required this.bouquet,
  }) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  }

  final BouquetDetail bouquet;

  @override
  State<BouquetTile> createState() => _BouquetTileState();
}

class _BouquetTileState extends State<BouquetTile> {
  showBouquetFormDialog() {
    context.read<BouquetCubit>().loadForEditing(widget.bouquet.id);

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: modalTopBorderRadius),
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<BouquetCubit>.value(
              value: context.read(),
            ),
            BlocProvider<NotificationCubit>.value(
              value: context.read(),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormBouquet(
              formTitle: "Modifier bouquet",
              onSubmit: (bouquetInputData) {
                context.read<BouquetCubit>().updateBouquet(bouquetInputData);
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
              context
                  .read<BouquetCubit>()
                  .setDeprecate(widget.bouquet.id, !widget.bouquet.obsolte);
            },
            backgroundColor:
                widget.bouquet.obsolte ? Colors.blue : Colors.blueGrey,
            foregroundColor: Colors.white,
            icon: widget.bouquet.obsolte ? Icons.restore : Icons.archive,
            label: widget.bouquet.obsolte ? "Restaurer" : 'Archiver',
          ),
        ],
      ),
      child: InkWell(
        onTap: showBouquetFormDialog,
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
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  children: [
                    Text(
                      widget.bouquet.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    BoldTag(
                      color: Colors.blue,
                      text:
                          "${widget.bouquet.nombreOfActiveSubcription} abonnement actif (s)",
                    ),
                    if (widget.bouquet.obsolte)
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 5),
                          BoldTag(color: Colors.orange, text: "archivé"),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
