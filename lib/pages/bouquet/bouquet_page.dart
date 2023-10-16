import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'widgets/add_bouquet_form.dart';

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
                return const Text(
                  "Aucun bouquet disponible",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
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
