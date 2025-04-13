import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
// Import Entities nếu cần (ví dụ: AuthToken, User)

abstract class AuthRepository {
  // Trả về true nếu đã đăng nhập, false nếu chưa
  Future<Either<Failure, bool>> isLoggedIn();

  // Các phương thức khác cho Auth (login, signup, logout...)
  // Future<Either<Failure, User>> login(String email, String password);
  // Future<Either<Failure, void>> logout();
}
