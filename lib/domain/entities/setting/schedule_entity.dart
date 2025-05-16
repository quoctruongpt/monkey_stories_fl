class ScheduleEntity {
  final List<String> weekdays;
  final ScheduleTimeEntity time;

  ScheduleEntity({required this.weekdays, required this.time});
}

class ScheduleTimeEntity {
  final int hour;
  final int minute;

  ScheduleTimeEntity({required this.hour, required this.minute});

  Map<String, dynamic> toJson() {
    return {'hour': hour, 'minute': minute};
  }
}
