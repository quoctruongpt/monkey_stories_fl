enum LeaveContactRole { Student, Parent }

class LeaveContactRoleItem {
  final LeaveContactRole value;
  final String label;

  const LeaveContactRoleItem({required this.value, required this.label});
}

final List<LeaveContactRoleItem> leaveContactRoles = [
  const LeaveContactRoleItem(
    value: LeaveContactRole.Student,
    label: 'Học sinh',
  ),
  const LeaveContactRoleItem(
    value: LeaveContactRole.Parent,
    label: 'Phụ huynh',
  ),
];
