part of 'user_cubit.dart';

class UserState extends Equatable {
  final UserEntity? user;

  const UserState({this.user});

  UserState copyWith({UserEntity? user}) {
    return UserState(user: user);
  }

  @override
  List<Object?> get props => [user];
}
