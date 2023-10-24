import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/subcriptionFilter/subscription_filter_cubit.dart';

import 'filter_item.dart';

class SubscriptionFilter extends StatefulWidget {
  const SubscriptionFilter({
    super.key,
  });

  @override
  State<SubscriptionFilter> createState() => _SubscriptionFilterState();
}

class _SubscriptionFilterState extends State<SubscriptionFilter> {
  var _selectedFilter = SubscriptionFilterType.active;
  StreamSubscription<SubscriptionFilterState>? _streamSubscription;
  @override
  void initState() {
    context.read<SubscriptionFilterCubit>().setCurrentFilter(_selectedFilter);
    _streamSubscription = context
        .read<SubscriptionFilterCubit>()
        .stream
        .listen(listenFilterStateChange);
    listenFilterStateChange(context.read<SubscriptionFilterCubit>().state);
    super.initState();
  }

  void listenFilterStateChange(event) {
    if (event is SubscriptionFilterLoaded) {
      setState(() {
        _selectedFilter = event.currentFilter;
      });
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        children: [
          FilterItem(
            color: Colors.blue,
            text: "Abon. actifs + à venirs",
            icon: Icons.now_widgets_rounded,
            isSelected: _selectedFilter == SubscriptionFilterType.active,
            onTap: () {
              context
                  .read<SubscriptionFilterCubit>()
                  .setCurrentFilter(SubscriptionFilterType.active);
            },
          ),
          FilterItem(
            color: Colors.red,
            text: "Abon. non payés",
            icon: Icons.money_off,
            isSelected: _selectedFilter == SubscriptionFilterType.noPaid,
            onTap: () {
              context
                  .read<SubscriptionFilterCubit>()
                  .setCurrentFilter(SubscriptionFilterType.noPaid);
            },
          ),
        ],
      ),
    );
  }
}
