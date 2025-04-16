class ProfileEntity {
  final int id;
  final String name;
  final int yearOfBirth;
  final String? avatarPath;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.yearOfBirth,
    this.avatarPath,
  });
}
