import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:monkey_stories/core/error/failures.dart';

// Type là kiểu dữ liệu trả về thành công
// Params là kiểu dữ liệu tham số đầu vào
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Dùng khi UseCase không cần tham số đầu vào
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
