// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jamanacanal/daos/subscription_dao.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/models/subscription_detail.dart';
import 'package:jamanacanal/notification/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const notifcationPlanificatorJobKey = "notifcation_planificator_job_key";
const notifcationPlanificatorJobName = "notifcation_planificator_job_name";

const lastPlanificationDayKey = "last_planification_date_key";
final subscriptionDao = SubscriptionsDao(AppDatabase());

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case notifcationPlanificatorJobKey:
        handleD2Planification();
        break;
    }
    return Future.value(true);
  });
}

class JobManager {
  Future<void> init() async {
    try {
      await Workmanager().initialize(
        callbackDispatcher,
        // isInDebugMode: true,
      );

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
  await assessPlanificationReset();

  final prendingNotifications =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  final pendingNotificationIds = prendingNotifications.map((p) => p.id);

  if (!notificationClosureTimeExceded()) {
    var subscriptions = await subscriptionsForD2();
    final subscriptionsToPlan = subscriptions.where((subcriptionForD2) {
      return !pendingNotificationIds.contains(subcriptionForD2.id);
    });

    for (var subcriptionToPlan in subscriptionsToPlan) {
      await zonedScheduleNotification(subcriptionToPlan);
    }
  }
}

Future<void> assessPlanificationReset() async {
  const resetAllPlanificationKey = "resetAllPlanificationKey";
  final prefs = await SharedPreferences.getInstance();
  final resetAllPlanification = prefs.getBool(resetAllPlanificationKey);
  if (resetAllPlanification == null || resetAllPlanification) {
    await removeAllNotification();
    await prefs.setBool(resetAllPlanificationKey, false);
  }
}

Future<Iterable<SubscriptionDetail>> subscriptionsForD2() async {
  final subscriptions = await subscriptionDao.allActiveSubscriptionDetails();
  return subscriptions.where((element) {
    var d2Deadline = element.endDate.add(const Duration(days: -2));
    return DateUtils.dateOnly(d2Deadline) == DateUtils.dateOnly(DateTime.now());
  });
}

bool notificationClosureTimeExceded() {
  final currentTime = TimeOfDay.now();
  const gap = 15;

  return currentTime.hour > timeOfNotification.hour ||
      currentTime.hour == timeOfNotification.hour &&
          currentTime.minute + gap >= currentTime.minute;
}
