part of 'user_cubit.dart';

class UserState extends Equatable {
  final User? user;

  const UserState({this.user});

  UserState copyWith({User? user}) {
    return UserState(user: user);
  }

  @override
  List<Object?> get props => [user];
}
