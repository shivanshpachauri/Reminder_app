import 'dart:js';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
// import 'Reminder.dart'; // Make sure to import the Reminder model
import 'ReminderForm.dart';
import 'package:reminder_app/Reminder.dart';
class ReminderProvider extends ChangeNotifier {
  final List<Reminder> _reminders = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<Reminder> get reminders => _reminders;

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    scheduleReminder(reminder);
    notifyListeners();
  }

  void scheduleReminder(Reminder reminder) async {
    final now = tz.TZDateTime.now(tz.local);
    final dayOfWeek = _dayOfWeekToInt(reminder.day);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      reminder.time.hour,
      reminder.time.minute,
    ).add(Duration(days: (dayOfWeek - now.weekday + 7) % 7));

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Notifications',
      channelDescription: 'Channel for Reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _reminders.length,
      'Reminder',
      '${reminder.activity} at ${reminder.time.format(context as BuildContext)}',
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  int _dayOfWeekToInt(String day) {
    switch (day) {
      case 'Monday':
        return DateTime.monday;
      case 'Tuesday':
        return DateTime.tuesday;
      case 'Wednesday':
        return DateTime.wednesday;
      case 'Thursday':
        return DateTime.thursday;
      case 'Friday':
        return DateTime.friday;
      case 'Saturday':
        return DateTime.saturday;
      case 'Sunday':
        return DateTime.sunday;
      default:
        throw Exception('Invalid day');
    }
  }
}
