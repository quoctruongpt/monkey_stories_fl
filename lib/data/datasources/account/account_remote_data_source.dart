import 'package:dio/dio.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/account/load_update_response_model.dart';
import 'package:monkey_stories/data/models/api_response.dart';

abstract class AccountRemoteDataSource {
  Future<ApiResponse<LoadUpdateResponseModel>> loadUpdate();
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final Dio dio;

  AccountRemoteDataSourceImpl({required this.dio});

  @override
  Future<ApiResponse<LoadUpdateResponseModel>> loadUpdate() async {
    final response = await dio.get(ApiEndpoints.loadUpdate);

    return ApiResponse.fromJson(
      response.data,
      (json, res) =>
          LoadUpdateResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
