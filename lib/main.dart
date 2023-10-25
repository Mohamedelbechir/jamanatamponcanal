import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/cubit/futureSubscriptionPayment/future_subscription_payment_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/cubit/subcriptionFilter/subscription_filter_cubit.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/daos/bouquet_dao.dart';
import 'package:jamanacanal/daos/customer_dao.dart';
import 'package:jamanacanal/daos/decoder_dao.dart';
import 'package:jamanacanal/daos/subscription_dao.dart';
import 'package:jamanacanal/daos/future_subscription_payment_dao.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/pages/application_pages_container.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jamanacanal/notification/notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLocalTimeZone();
  await initializeFlutterLocalNotificationsPlugin();
  final notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  final database = AppDatabase();

  runApp(Application(database, notificationAppLaunchDetails));
}

class Application extends StatefulWidget {
  const Application(
    this.appDatabase,
    this.notificationAppLaunchDetails, {
    super.key,
  });
  final AppDatabase appDatabase;
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return buildMultiRepositories(child);
      },
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NotificationCubit(),
          ),
          BlocProvider(
            create: (context) => SubscriptionFilterCubit(),
          ),
          BlocProvider(
            create: (context) => SubscriptionCubit(
              context.read(),
              context.read(),
              context.read(),
              context.read(),
              context.read(),
              context.read(),
            ),
          ),
          BlocProvider(
            create: (context) => BouquetCubit(
              context.read(),
              context.read(),
            ),
          ),
          BlocProvider(
            create: (context) => CustomerCubit(
              context.read(),
              context.read(),
              context.read(),
              context.read(),
              context.read(),
            ),
          ),
          BlocProvider(
            create: (context) => FutureSubscriptionPaymentCubit(
              context.read(),
              context.read(),
              context.read(),
            ),
          ),
        ],
        child: ApplicationPagesContainer(
          notificationAppLaunchDetails: widget.notificationAppLaunchDetails,
        ),
      ),
    );
  }

  MultiRepositoryProvider buildMultiRepositories(Widget? child) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CustomersDao>(
          create: (_) => CustomersDao(widget.appDatabase),
        ),
        RepositoryProvider<SubscriptionsDao>(
          create: (_) => SubscriptionsDao(widget.appDatabase),
        ),
        RepositoryProvider<BouquetsDao>(
          create: (_) => BouquetsDao(widget.appDatabase),
        ),
        RepositoryProvider<DecodersDao>(
          create: (_) => DecodersDao(widget.appDatabase),
        ),
        RepositoryProvider<FutureSubscriptionPaymentsDao>(
          create: (_) => FutureSubscriptionPaymentsDao(widget.appDatabase),
        )
      ],
      child: child!,
    );
  }
}
