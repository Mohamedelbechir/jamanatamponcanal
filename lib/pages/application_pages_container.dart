import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/cubit/futureSubscriptionPayment/future_subscription_payment_cubit.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/pages/futureSubcription/future_subscription_payment_page.dart';
import 'package:jamanacanal/pages/subscription/subscription_page.dart';
import 'package:jamanacanal/pages/bouquet/bouquet_page.dart';
import 'package:jamanacanal/pages/customer/customer.dart';
import 'package:jamanacanal/notification/notification.dart';
import 'package:jamanacanal/sync/data_sync_service.dart';
import '../widgets/app_title.dart';

enum AppPage { home, bouquet, about }

class ApplicationPagesContainer extends StatefulWidget {
  const ApplicationPagesContainer({
    super.key,
    required this.notificationAppLaunchDetails,
    required this.dataSyncService,
  });
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  final DataSyncService dataSyncService;

  @override
  State<ApplicationPagesContainer> createState() =>
      _ApplicationPagesContainerState();
}

class _ApplicationPagesContainerState extends State<ApplicationPagesContainer>
    with WidgetsBindingObserver {
  final _pages = <Widget>[
    const SubscriptionPage(),
    const FutureSubscriptionPaymentPage(),
    const CustomerPage(),
    const BouquetPage(),
  ];

  int _selectedIndex = 0;
  StreamSubscription<void>? _syncCompletedSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.dataSyncService.startListening();
    _syncCompletedSubscription =
        widget.dataSyncService.onSyncCompleted.listen((_) {
      _refreshAllData();
    });
    isAndroidPermissionGranted();
    requestPermissions();
    configureDidReceiveLocalNotificationSubject();
    configureSelectNotificationSubject(context);
    if (widget.notificationAppLaunchDetails?.didNotificationLaunchApp ??
        false) {
      if (widget.notificationAppLaunchDetails!.notificationResponse?.payload !=
          null) {
        handleNotificationResponse(
            widget.notificationAppLaunchDetails!.notificationResponse);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.dataSyncService.syncIfNeeded();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _syncCompletedSubscription?.cancel();
    super.dispose();
  }

  void _refreshAllData() {
    if (!mounted) return;
    context.read<SubscriptionCubit>().refreshSubscription();
    context.read<FutureSubscriptionPaymentCubit>().load();
    context.read<CustomerCubit>().loadCustomerDetails();
    context.read<BouquetCubit>().load();
  }

  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
  }

  void configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((NotificationResponse receivedNotification) async {
      debugPrint(receivedNotification.actionId);
    });
  }

  Future<void> isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      debugPrint("Notification grant = $granted");
    }
  }

  _onItemTapped(int selectedIndex) {
    _loadPageData(selectedIndex);
    setState(() {
      _selectedIndex = selectedIndex;
    });
  }

  void _loadPageData(int selectedIndex) {
    final pageDataLoaders = <int, VoidCallback>{
      0: () {
        context.read<SubscriptionCubit>().refreshSubscription();
      },
      1: () {
        context.read<FutureSubscriptionPaymentCubit>().load();
      },
      2: () {
        context.read<CustomerCubit>().loadCustomerDetails();
      },
      3: () {
        context.read<BouquetCubit>().load();
      }
    };

    if (pageDataLoaders.containsKey(selectedIndex)) {
      pageDataLoaders[selectedIndex]!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppTitle(),
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.now_widgets_rounded),
            label: 'Abonnements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Payés non abnt.',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Abonnés',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Bouquets',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
