import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/pages/subscription/subscription_page.dart';
import 'package:jamanacanal/pages/about/about.dart';
import 'package:jamanacanal/pages/bouquet/bouquet_page.dart';
import 'package:jamanacanal/pages/customer/customer.dart';
import 'package:jamanacanal/notification/notification.dart';

import '../widgets/app_title.dart';

enum AppPage { home, bouquet, about }

class ApplicationPagesContainer extends StatefulWidget {
  const ApplicationPagesContainer({
    super.key,
    required this.notificationAppLaunchDetails,
  });
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  @override
  State<ApplicationPagesContainer> createState() =>
      _ApplicationPagesContainerState();
}

class _ApplicationPagesContainerState extends State<ApplicationPagesContainer> {
  final _pages = <Widget>[
    const SubscriptionPage(),
    const CustomerPage(),
    const BouquetPage(),
    const AboutPage()
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
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
    if (selectedIndex == 0) {
      context.read<SubscriptionCubit>().refreshSubscription();
    }
    if (selectedIndex == 1) {
      context.read<CustomerCubit>().loadCustomerDetails();
    }
    if (selectedIndex == 2) {
      context.read<BouquetCubit>().load();
    }
    setState(() {
      _selectedIndex = selectedIndex;
    });
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
            icon: Icon(Icons.person),
            label: 'Abonnés',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Bouquets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_sharp),
            label: 'Apropos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
