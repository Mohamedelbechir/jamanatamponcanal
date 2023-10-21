import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/cubit/subcriptionFilter/subscription_filter_cubit.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/models/subscription_detail.dart';
import 'package:jamanacanal/pages/subscription/subscription_page.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

int id = 0;
const String callCustomerId = "id_call_customer";
const String notificationSound = "notification";

const initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<NotificationResponse> didReceiveLocalNotificationStream =
    StreamController<NotificationResponse>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

void configureSelectNotificationSubject(BuildContext context) {
  selectNotificationStream.stream.listen((String? payload) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) {
        context
            .read<SubscriptionFilterCubit>()
            .setCurrentFilter(SubscriptionFilterType.active);

        return MultiBlocProvider(
          providers: [
            BlocProvider<SubscriptionCubit>.value(
              value: context.read(),
            ),
            BlocProvider<NotificationCubit>.value(
              value: context.read(),
            ),
            BlocProvider<SubscriptionFilterCubit>.value(
              value: context.read(),
            ),
          ],
          child: const SubscriptionPage(),
        );
      },
    ));
  });
}

Future<void> initializeFlutterLocalNotificationsPlugin() async {
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == callCustomerId) {
            launchUrl(Uri.parse('tel:${notificationResponse.payload}'));
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
}

Future<void> zonedScheduleNotification(SubscriptionDetail subscription) async {
  setLocalMessagesForTimeago();

  await flutterLocalNotificationsPlugin.zonedSchedule(
    subscription.id,
    'Abonnement CANAL+',
    "Merci de renouveler l'abonn. de ${subscription.customerFullName}",
    _notificateDate(subscription.endDate),
    const NotificationDetails(
        android: AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      priority: Priority.high,
      importance: Importance.high,
      playSound: true,
      visibility: NotificationVisibility.public,
      sound: RawResourceAndroidNotificationSound(notificationSound),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          callCustomerId,
          'Passer un appel',
          showsUserInterface: true,
        ),
      ],
    )),
    payload: subscription.phoneNumber,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

tz.TZDateTime _notificateDate(DateTime date) {
  return tz.TZDateTime.from(
    DateTime(
        date.year,
        date.month,
        date.day - 2,
        9, // heure
        30, // minutes
        30 // secode
        ),
    tz.local,
  );
}

void setLocalMessagesForTimeago() {
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
}
