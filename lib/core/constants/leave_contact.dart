enum LeaveContactRole { student, parent }

class LeaveContactRoleItem {
  final LeaveContactRole value;
  final String label;

  const LeaveContactRoleItem({required this.value, required this.label});
}

final List<LeaveContactRoleItem> leaveContactRoles = [
  const LeaveContactRoleItem(
    value: LeaveContactRole.student,
    label: 'app.popup_c3.role.student',
  ),
  const LeaveContactRoleItem(
    value: LeaveContactRole.parent,
    label: 'app.popup_c3.role.parent',
  ),
];
