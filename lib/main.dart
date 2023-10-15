import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/bouquet/bouquet_cubit.dart';
import 'package:jamanacanal/cubit/customer/customer_cubit.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/daos/bouquet_dao.dart';
import 'package:jamanacanal/daos/customer_dao.dart';
import 'package:jamanacanal/daos/decoder_dao.dart';
import 'package:jamanacanal/daos/subscription_dao.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/pages/application_pages_container.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  runApp(Application(database));
}

class Application extends StatelessWidget {
  const Application(this.appDatabase, {super.key});
  final AppDatabase appDatabase;
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
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<CustomersDao>(
              create: (_) => CustomersDao(appDatabase),
            ),
            RepositoryProvider<SubscriptionsDao>(
              create: (_) => SubscriptionsDao(appDatabase),
            ),
            RepositoryProvider<BouquetsDao>(
              create: (_) => BouquetsDao(appDatabase),
            ),
            RepositoryProvider<DecodersDao>(
              create: (_) => DecodersDao(appDatabase),
            )
          ],
          child: child!,
        );
      },
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SubscriptionCubit(
              context.read(),
              context.read(),
              context.read(),
              context.read(),
            ),
          ),
          BlocProvider(
            create: (context) => CustomerCubit(
              context.read(),
              context.read(),
            ),
          ),
          BlocProvider(
            create: (context) => BouquetCubit(context.read()),
          ),
        ],
        child: const ApplicationPagesContainer(),
      ),
    );
  }
}
