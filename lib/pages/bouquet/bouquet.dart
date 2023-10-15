import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'widgets/add_bouquet_form.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:jamanacanal/widgets/tag.dart';

class BouquetPage extends StatefulWidget {
  const BouquetPage({super.key});

  @override
  State<BouquetPage> createState() => _BouquetPageState();
}

class _BouquetPageState extends State<BouquetPage> {
  @override
  void initState() {
    super.initState();
    context.read<BouquetCubit>().load();

    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  }

  showAddBouquetFormDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: modalTopBorderRadius),
      builder: (_) {
        return BlocProvider<BouquetCubit>.value(
          value: context.read(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: AddBouquetForm(),
          ),
        );
      },
    );
  }

  final locale = 'fr';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<BouquetCubit, BouquetState>(
          buildWhen: (prev, next) => next is BouquetLoaded,
          builder: (context, state) {
            if (state is BouquetLoaded) {
              if (state.bouquets.isEmpty) {
                return const Text(
                  "Aucun bouquet disponible",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                );
              }
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, index) {
                  final bouquet = state.bouquets.elementAt(index);
                  return ListTile(
                    title: Text(
                      bouquet.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            buildTag("ajouté ${timeago.format(
                              bouquet.createAt!,
                              locale: locale,
                            )}")
                          ],
                        ),
                        if (bouquet.updateAt != null)
                          buildTag(timeago.format(
                            bouquet.updateAt!,
                            locale: locale,
                          ))
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, index) => const Divider(),
                itemCount: state.bouquets.length,
              );
            }
            return const CircularProgressIndicator();
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
