class Weekday {
  final String id;
  final String label;

  Weekday({required this.id, required this.label});
}

final List<Weekday> weekdays = [
  Weekday(id: 'mon', label: 'T2'),
  Weekday(id: 'tue', label: 'T3'),
  Weekday(id: 'wed', label: 'T4'),
  Weekday(id: 'thu', label: 'T5'),
  Weekday(id: 'fri', label: 'T6'),
  Weekday(id: 'sat', label: 'T7'),
  Weekday(id: 'sun', label: 'CN'),
];
