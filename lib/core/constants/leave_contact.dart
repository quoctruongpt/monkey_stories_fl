enum LeaveContactRole { Student, Parent }

class LeaveContactRoleItem {
  final LeaveContactRole value;
  final String label;

  const LeaveContactRoleItem({required this.value, required this.label});
}

final List<LeaveContactRoleItem> leaveContactRoles = [
  const LeaveContactRoleItem(
    value: LeaveContactRole.Student,
    label: 'app.popup_c3.role.student',
  ),
  const LeaveContactRoleItem(
    value: LeaveContactRole.Parent,
    label: 'app.popup_c3.role.parent',
  ),
];
