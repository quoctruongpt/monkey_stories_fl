import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String? email;
  final String? name;
  final String? phone;
  final String? avatar;

  const User({
    required this.id,
    this.email,
    this.name,
    this.phone,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, email, name, phone, avatar];
}
