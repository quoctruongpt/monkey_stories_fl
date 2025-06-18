import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // Nếu có properties, ví dụ: final String message;
  // thì cần thêm vào constructor và props
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => []; // Thêm properties vào đây nếu có
}

// Lỗi chung từ Server
class ServerFailure extends Failure {
  final String message;
  const ServerFailure({this.message = 'Server Error'});

  @override
  List<Object> get props => [message];
}

class ServerFailureWithCode<T> extends Failure {
  final int code;
  final String message;
  final T? data;

  const ServerFailureWithCode({
    this.code = 200,
    this.message = 'Server Error',
    this.data,
  });

  @override
  List<Object> get props => [code, message];
}

// Lỗi từ Cache (ví dụ: SharedPreferences)
class CacheFailure extends Failure {
  final String message;
  const CacheFailure({this.message = 'Cache Error'});

  @override
  List<Object> get props => [message];
}

// Lỗi mạng
class NetworkFailure extends Failure {
  final String message;
  const NetworkFailure({this.message = 'Network Error'});

  @override
  List<Object> get props => [message];
}

// Các loại lỗi cụ thể khác nếu cần...

extension FailureMessageExtension on Failure {
  String get displayMessage {
    if (this is ServerFailure) {
      return (this as ServerFailure).message;
    } else if (this is CacheFailure) {
      return (this as CacheFailure).message;
    } else if (this is NetworkFailure) {
      return (this as NetworkFailure).message;
    }
    // Thêm các kiểu Failure cụ thể khác nếu cần
    return 'Đã xảy ra lỗi không mong muốn.'; // Thông điệp mặc định
  }
}
