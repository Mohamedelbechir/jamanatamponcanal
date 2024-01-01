// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jamanacanal/daos/subscription_dao.dart';
import 'package:jamanacanal/firebase_options.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/subscription_detail.dart';
import 'package:jamanacanal/notification/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';

const notifcationPlanificatorJobKey = "notifcation_planificator_job_key";
const notifcationPlanificatorJobName = "notifcation_planificator_job_name";

const lastPlanificationDayKey = "last_planification_date_key";
final subscriptionDao = SubscriptionsDao(AppDatabase());

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case notifcationPlanificatorJobKey:
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        await handleD2Planification();
        break;
    }
    return Future.value(true);
  });
}

class JobManager {
  Future<void> init() async {
    try {
      await Workmanager().initialize(callbackDispatcher);

      await Workmanager().registerPeriodicTask(
        notifcationPlanificatorJobName,
        notifcationPlanificatorJobKey,
        frequency: const Duration(minutes: 15),
      );
    } catch (e) {
      print("erreur");
    }
  }
}

Future<void> handleD2Planification() async {
  var dayNotificationExecuted = await isDayNotificationExecuted(DateTime.now());

  var subscriptions = await subscriptionsForD2();

  if (notificationClosureTimeExceded() &&
      !dayNotificationExecuted &&
      subscriptions.isNotEmpty) {
    await removeAllNotification();

    for (var subcriptionToPlan in subscriptions) {
      await Future.delayed(const Duration(seconds: 2));
      await showNotification(subcriptionToPlan);
    }
    await markDayAsNotified(DateTime.now());
  }
}

const dayNotificationKey = "dayNotificationKey";
Future<void> markDayAsNotified(DateTime day) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt(
    dayNotificationKey,
    DateUtils.dateOnly(day).millisecondsSinceEpoch,
  );
}

Future<bool> isDayNotificationExecuted(DateTime day) async {
  final prefs = await SharedPreferences.getInstance();

  final savedDaySinceApprochValue = prefs.getInt(dayNotificationKey);
  var givenDayMillisecondsSinceEpoch =
      DateUtils.dateOnly(day).millisecondsSinceEpoch;
  return savedDaySinceApprochValue == givenDayMillisecondsSinceEpoch;
}

Future<List<SubscriptionDetail>> subscriptionsForD2() async {
  final subscriptions = await subscriptionDao.allActiveSubscriptionDetails();
  return subscriptions.where((element) {
    var d2Deadline = element.endDate.add(const Duration(days: -2));
    return DateUtils.dateOnly(d2Deadline) == DateUtils.dateOnly(DateTime.now());
  }).toList();
}

bool notificationClosureTimeExceded() {
  final currentTime = TimeOfDay.now();

  return currentTime.hour > timeOfNotification.hour ||
      currentTime.hour == timeOfNotification.hour &&
          currentTime.minute >= timeOfNotification.minute;
}
