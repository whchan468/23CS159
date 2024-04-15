import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:medireminder/Models/DB%20Model/med_log.dart';
import 'package:medireminder/Models/notif.dart';
import 'package:medireminder/Services/s_database.dart';

class SNotification {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'high_importance_channel',
            channelKey: 'high_importance_channel',
            channelName: 'notification',
            channelDescription: 'reminder',
            defaultColor: Colors.white,
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
            criticalAlerts: true,
            locked: true)
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'notification',
          channelGroupName: '1',
        )
      ],
      debug: true,
    );
    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  static Future<void> createScheduleNotification(Notif notif) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: 'high_importance_channel',
          title: "Medicine Reminder: ${notif.name}",
          locked: true,
          notificationLayout: NotificationLayout.Default,
          payload: {
            'name': notif.name,
            'dateTime': '${notif.dateTime.millisecondsSinceEpoch}',
            'dosage': '${notif.dosage}',
            'remarks': notif.remarks,
            'mid': '${notif.mid}',
            'snoozed': '${notif.snoozed ? 1 : 0}',
          },
          body: '${notif.dosage} dose     ${notif.remarks}',
        ),
        actionButtons: [
          //    finish
          NotificationActionButton(key: 'Finish', label: 'Finish'),

          //    snoozed
          NotificationActionButton(key: 'Snooze', label: 'Snooze'),
        ],
        schedule: NotificationCalendar(
          repeats: false,
          allowWhileIdle: true,
          preciseAlarm: true,
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          year: notif.dateTime.year,
          month: notif.dateTime.month,
          day: notif.dateTime.day,
          hour: notif.dateTime.hour,
          minute: notif.dateTime.minute,
          second: 0,
          millisecond: 0,
        ));
  }

  static Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    late int mid;
    late int exp_time;
    late bool snoozed;
    final data = receivedAction.payload;
    if (receivedAction.payload != null) {
      mid = int.parse(data!["mid"]!);
      exp_time = int.parse(data["dateTime"]!);
      if (int.parse(data["snoozed"]!) == 1) {
        snoozed = true;
      } else {
        snoozed = false;
      }
    }
    if (receivedAction.buttonKeyPressed == 'Finish') {
      //    Save record to Medlog after pressing finish
      int take_time = receivedAction.actionDate!.millisecondsSinceEpoch;

      MedLog entry = MedLog(
          mid: mid, take_time: take_time, exp_time: exp_time, snoozed: snoozed);

      // Create SQL entry
      await SDataBase().addToMedlog(entry);
    }

    if (receivedAction.buttonKeyPressed == 'Snooze') {
      //    Create another schedule 10 mins later and set snoozed = true
      Duration duration = const Duration(minutes: 1);
      var dosage = int.parse(data!["dosage"]!);
      createScheduleNotification(Notif(
          name: data['name']!,
          dateTime: DateTime.fromMillisecondsSinceEpoch(exp_time).add(duration),
          dosage: dosage,
          remarks: data['remarks']!,
          mid: mid,
          snoozed: true));
    }
  }
}
