import 'package:dio/dio.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/account/load_update_response_model.dart';
import 'package:monkey_stories/data/models/account/update_user_info.dart';
import 'package:monkey_stories/data/models/api_response.dart';

abstract class AccountRemoteDataSource {
  Future<ApiResponse<LoadUpdateResponseModel>> loadUpdate({
    bool showConnectionErrorDialog = true,
  });

  Future<ApiResponse<Null>> updateUserInfo(UpdateUserInfoParams params);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final Dio dio;

  AccountRemoteDataSourceImpl({required this.dio});

  @override
  Future<ApiResponse<LoadUpdateResponseModel>> loadUpdate({
    bool showConnectionErrorDialog = true,
  }) async {
    final response = await dio.get(
      ApiEndpoints.loadUpdate,
      options: Options(
        extra: {
          AppConstants.showConnectionErrorDialog: showConnectionErrorDialog,
        },
      ),
    );

    return ApiResponse.fromJson(
      response.data,
      (json, res) =>
          LoadUpdateResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<Null>> updateUserInfo(UpdateUserInfoParams params) async {
    final response = await dio.post(
      ApiEndpoints.updateUserInfo,
      data: params.toJson(),
    );

    return ApiResponse.fromJson(response.data, (json, res) => null);
  }
}
