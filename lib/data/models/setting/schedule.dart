import 'dart:convert';

class Schedule {
  final List<String> weekdays;
  final ScheduleTime time;

  Schedule({required this.weekdays, required this.time});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    final weekdaysString = json['day_of_week'] as String;
    final timeString = json['time'] as String;

    final weekdays = (jsonDecode(weekdaysString) as List).cast<String>();
    final time = jsonDecode(timeString);

    return Schedule(weekdays: weekdays, time: ScheduleTime.fromJson(time));
  }

  String weekdaysToJson() {
    return jsonEncode(weekdays);
  }

  String timeToJson() {
    return time.toJson();
  }
}

class ScheduleTime {
  final int hour;
  final int minute;

  ScheduleTime({required this.hour, required this.minute});

  factory ScheduleTime.fromJson(Map<String, dynamic> json) {
    return ScheduleTime(hour: json['hour'], minute: json['minute']);
  }

  String toJson() {
    return jsonEncode({'hour': hour, 'minute': minute});
  }
}
