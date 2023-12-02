import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/cubit/subcriptionFilter/subscription_filter_cubit.dart';
import 'package:jamanacanal/cubit/subscription/subscription_cubit.dart';
import 'package:jamanacanal/models/subscription_detail.dart';
import 'package:jamanacanal/pages/subscription/subscription_page.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

const String callCustomerId = "id_call_customer";
const String notificationSound = "notification";
const timeOfNotification = TimeOfDay(hour: 9, minute: 30);

const initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final didReceiveLocalNotificationStream =
    StreamController<NotificationResponse>.broadcast();

final selectNotificationStream = StreamController<String?>.broadcast();

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
            .setCustomer(SubscriptionDetail.fromJson(payload!).customerId);

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
    onDidReceiveNotificationResponse: handleNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

void handleNotificationResponse(notificationResponse) {
  switch (notificationResponse.notificationResponseType) {
    case NotificationResponseType.selectedNotification:
      selectNotificationStream.add(notificationResponse.payload);
      break;
    case NotificationResponseType.selectedNotificationAction:
      if (notificationResponse.actionId == callCustomerId) {
        final subscription =
            SubscriptionDetail.fromJson(notificationResponse.payload!);
        if (subscription.phoneNumber != null) {
          launchUrl(Uri.parse('tel:${subscription.phoneNumber}'));
        }
      }
      break;
  }
}

Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
}

Future<void> zonedScheduleNotification(SubscriptionDetail subscription) async {
  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      subscription.id,
      'Abonnement CANAL+',
      "Merci de renouveler l'abonn. de ${subscription.customerFullName}",
      notificationDate(),
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'jamanacanal_channel_id',
        'jamanacanal_channel_name',
        channelDescription: 'jamana canal',
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
      payload: subscription.toJson(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> showNotification(SubscriptionDetail subscription) async {
  try {
    await flutterLocalNotificationsPlugin.show(
      subscription.id,
      'Abonnement CANAL+',
      "Merci de renouveler l'abonn. de ${subscription.customerFullName}",
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'jamanacanal_channel_id',
        'jamanacanal_channel_name',
        channelDescription: 'jamana canal',
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
      payload: subscription.toJson(),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> removeNotification(int subscriptionId) async {
  await flutterLocalNotificationsPlugin.cancel(subscriptionId);
}

Future<void> removeAllNotification() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

tz.TZDateTime notificationDate() {
  configureLocalTimeZone();
  return tz.TZDateTime.from(
    DateUtils.dateOnly(DateTime.now()).add(Duration(
      hours: timeOfNotification.hour,
      minutes: timeOfNotification.minute,
    )),
    tz.local,
  );
}
