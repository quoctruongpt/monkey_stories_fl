import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/models/api_response.dart';

abstract class CourseRemoteData {
  Future<Either<ServerFailureWithCode, bool>> activeCourse(int profileId);
}

class CourseRemoteDataImpl extends CourseRemoteData {
  final Dio dio;

  CourseRemoteDataImpl({required this.dio});

  @override
  Future<Either<ServerFailureWithCode, bool>> activeCourse(
    int profileId,
  ) async {
    final response = await dio.post(
      ApiEndpoints.activeCourse,
      data: {'profile_id': profileId, 'course_id': AppConstants.courseId},
    );

    final data = ApiResponse.fromJson(response.data, (json, res) => null);

    if (data.status == ApiStatus.success) {
      return right(true);
    }

    return left(ServerFailureWithCode(message: data.message, code: data.code));
  }
}
