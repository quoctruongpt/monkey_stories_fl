import 'package:dio/dio.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/domain/usecases/leave_contact/save_contact_usecase.dart';

abstract class LeaveContactRemoteDataSource {
  Future<ApiResponse<Null>> saveContact(ContactParams params);
}

class LeaveContactRemoteDataSourceImpl extends LeaveContactRemoteDataSource {
  final Dio dio;

  LeaveContactRemoteDataSourceImpl({required this.dio});

  @override
  Future<ApiResponse<Null>> saveContact(ContactParams params) async {
    final response = await dio.post(
      ApiEndpoints.saveContact,
      data: params.toJson(),
    );

    return ApiResponse.fromJson(response.data, (json, res) {
      return null;
    });
  }
}
