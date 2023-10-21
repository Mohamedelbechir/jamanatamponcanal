import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import '../../widgets/empty_result.dart';
import 'widgets/form_bouquet.dart';

import 'widgets/bouquet_tile.dart';

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
  }

  showBouquetFormDialog() {
    context.read<BouquetCubit>().loadAddForm();
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
              formTitle: "Ajouter bouquet",
              onSubmit: (bouquetInputData) {
                context.read<BouquetCubit>().addBouquet(bouquetInputData.name);
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
        child: BlocBuilder<BouquetCubit, BouquetState>(
          buildWhen: (prev, next) => next is BouquetLoaded,
          builder: (context, state) {
            if (state is BouquetLoaded) {
              if (state.bouquets.isEmpty) {
                return const EmptyResult(text: "Aucun bouquet disponible");
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 5),
                  itemBuilder: (_, index) {
                    return BouquetTile(
                      bouquet: state.bouquets.elementAt(index),
                    );
                  },
                  itemCount: state.bouquets.length,
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showBouquetFormDialog,
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
