import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/subcriptionFilter/subscription_filter_cubit.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/daos/customer_dao.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/subscription_detail.dart';
import 'package:jamanacanal/utils/functions.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/empty_result.dart';
import 'widgets/form_subscription.dart';
import 'widgets/subscription_filter.dart';
import 'widgets/subscription_tile.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final pageController = PageController();
  var customers = <Customer>[];
  @override
  void initState() {
    context
        .read<SubscriptionFilterCubit>()
        .stream
        .listen(listenFilterStateChange);

    context.read<CustomersDao>().allCustomers.then((value) {
      setState(() {
        customers = value;
      });
    });

    super.initState();
  }

  void listenFilterStateChange(event) {
    if (event is SubscriptionFilterLoaded) {
      safeTry(() {
        pageController.jumpToPage(event.currentFilter.index);
      });
    }
  }

  showAddSubscriptionFormDialog() async {
    context.read<SubscriptionCubit>().loadAddingForm();

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: modalTopBorderRadius),
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<SubscriptionCubit>.value(value: context.read()),
            BlocProvider<SubscriptionFilterCubit>.value(value: context.read()),
            BlocProvider<NotificationCubit>.value(value: context.read()),
          ],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormSubscription(
              formTitle: "Ajouter abonnement",
              onSubmit: (subscriptionInputData) {
                context
                    .read<SubscriptionCubit>()
                    .addSubscription(subscriptionInputData);
              },
            ),
          ),
        );
      },
    );
  }

  String getEmptyMessage() {
    String emptyMessage = "Aucun abonnement disponible";

    final filterState = context.read<SubscriptionFilterCubit>().state;
    if (filterState is SubscriptionFilterLoaded) {
      emptyMessage = filterState.currentFilter == SubscriptionFilterType.noPaid
          ? "Aucun abonnement non payé disponible"
          : emptyMessage;
    }
    return emptyMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SubscriptionFilter(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Rechercher par abonné"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownSearch<Customer>(
                enabled: true,
                items: customers,
                selectedItem: _selectedCustomer,
                clearButtonProps: const ClearButtonProps(isVisible: true),
                popupProps: const PopupProps.menu(showSearchBox: true),
                itemAsString: (customer) {
                  return "${customer.lastName} ${customer.firstName}";
                },
                onChanged: (customer) {
                  context
                      .read<SubscriptionFilterCubit>()
                      .setCustomer(customer?.id);
                },
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  context
                      .read<SubscriptionFilterCubit>()
                      .setCurrentFilter(SubscriptionFilterType.values[index]);
                },
                children: [
                  Center(
                    child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                      buildWhen: (prev, next) => next is SubscriptionLoaded,
                      builder: (context, state) {
                        if (state is SubscriptionLoaded) {
                          return _buidSubscriptionList(state.subscriptions);
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                  Center(
                    child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                      buildWhen: (prev, next) {
                        return next is NoPaidSubscriptionLoaded;
                      },
                      builder: (context, state) {
                        if (state is NoPaidSubscriptionLoaded) {
                          return _buidSubscriptionList(state.subscriptions);
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: showAddSubscriptionFormDialog,
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Customer? get _selectedCustomer {
    return () {
      final filterState = context.read<SubscriptionFilterCubit>().state;
      if (filterState is SubscriptionFilterLoaded) {
        return customers
            .where((element) => element.id == filterState.customerId)
            .firstOrNull;
      }
    }();
  }

  StatelessWidget _buidSubscriptionList(
      List<SubscriptionDetail> subscriptions) {
    if (subscriptions.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(10.0),
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: subscriptions.length,
        itemBuilder: (context, index) {
          return SubscriptionTile(
            subscription: subscriptions.elementAt(index),
          );
        },
      );
    }
    return EmptyResult(text: getEmptyMessage());
  }

  Widget _listList(SubscriptionState state) {
    if (state is SubscriptionLoaded) {
      if (state.subscriptions.isNotEmpty) {
        return ListView.separated(
          padding: const EdgeInsets.all(10.0),
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: state.subscriptions.length,
          itemBuilder: (context, index) {
            return SubscriptionTile(
              subscription: state.subscriptions.elementAt(index),
            );
          },
        );
      }
      return EmptyResult(text: getEmptyMessage());
    }
    return const CircularProgressIndicator();
  }
}
