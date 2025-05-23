import 'package:logging/logging.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/data/models/setting/schedule.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

final logger = Logger('Schedule');

Future<void> initNotification(
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
) async {
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  const InitializationSettings settings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings);
}

Future<void> scheduleWeeklyNotification(
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  Schedule schedule,
) async {
  await flutterLocalNotificationsPlugin.cancelAll(); // Hủy tất cả thông báo cũ

  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

  for (String day in schedule.weekdays) {
    int dayOfWeek;
    switch (day) {
      case 'mon':
        dayOfWeek = DateTime.monday;
        break;
      case 'tue':
        dayOfWeek = DateTime.tuesday;
        break;
      case 'wed':
        dayOfWeek = DateTime.wednesday;
        break;
      case 'thu':
        dayOfWeek = DateTime.thursday;
        break;
      case 'fri':
        dayOfWeek = DateTime.friday;
        break;
      case 'sat':
        dayOfWeek = DateTime.saturday;
        break;
      case 'sun':
        dayOfWeek = DateTime.sunday;
        break;
      default:
        continue;
    }

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      schedule.time.hour,
      schedule.time.minute,
    );

    if (scheduledDate.weekday > dayOfWeek) {
      scheduledDate = scheduledDate.subtract(
        Duration(days: scheduledDate.weekday - dayOfWeek),
      );
    } else if (scheduledDate.weekday < dayOfWeek) {
      scheduledDate = scheduledDate.add(
        Duration(days: dayOfWeek - scheduledDate.weekday),
      );
    }

    final tz.TZDateTime nowForCompare = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    final tz.TZDateTime scheduledDateForCompare = tz.TZDateTime(
      tz.local,
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      schedule.time.hour,
      schedule.time.minute,
    );

    if (scheduledDateForCompare.isBefore(nowForCompare)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
      // Đảm bảo lại ngày trong tuần sau khi thêm 7 ngày (phòng trường hợp lỗi logic)
      if (scheduledDate.weekday > dayOfWeek) {
        scheduledDate = scheduledDate.subtract(
          Duration(days: scheduledDate.weekday - dayOfWeek),
        );
      } else if (scheduledDate.weekday < dayOfWeek) {
        scheduledDate = scheduledDate.add(
          Duration(days: dayOfWeek - scheduledDate.weekday),
        );
      }
    }

    // Cập nhật giờ phút cho scheduledDate một lần nữa để chắc chắn
    scheduledDate = tz.TZDateTime(
      tz.local,
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      schedule.time.hour,
      schedule.time.minute,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'weekly_notification_channel_id',
          'Weekly Study Reminders',
          channelDescription: 'Channel for weekly study reminders',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_launcher',
        );
    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentSound: true,
          presentBadge: true,
          presentAlert: true,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      dayOfWeek + schedule.time.hour * 100 + schedule.time.minute,
      'Monkey Stories',
      AppLocalizations.of(
        navigatorKey.currentContext!,
      ).translate('app.schedule_manager.notification_title'),
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
    logger.info(
      'Scheduled for: ${dayOfWeekToString(dayOfWeek)} at ${schedule.time.hour}:${schedule.time.minute}, actual: $scheduledDate local_now: $now',
    );
  }
}

String dayOfWeekToString(int dayOfWeek) {
  switch (dayOfWeek) {
    case DateTime.monday:
      return 'Mon';
    case DateTime.tuesday:
      return 'Tue';
    case DateTime.wednesday:
      return 'Wed';
    case DateTime.thursday:
      return 'Thu';
    case DateTime.friday:
      return 'Fri';
    case DateTime.saturday:
      return 'Sat';
    case DateTime.sunday:
      return 'Sun';
    default:
      return '';
  }
}
