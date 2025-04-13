import 'package:monkey_stories/core/constants/constants.dart';

class ApiResponse<T> {
  final ApiStatus status; // Changed to enum
  final String message;
  final int code;
  final T? data; // Make data nullable

  ApiResponse({
    required this.status,
    required this.message,
    required this.code,
    this.data, // Remove required
  });

  /// Factory constructor to create an [ApiResponse] from a JSON map.
  ///
  /// Requires a `fromJsonT` function to parse the generic `data` field.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      // Parse status string using the enum's factory, handle potential null
      status: ApiStatus.fromString(json['status'] as String?),
      message:
          json['message'] as String? ?? '', // Default to empty string if null
      code:
          json['code'] as int? ??
          -1, // Default to -1 or another indicator if null
      // Use the provided function to parse the generic data
      data: fromJsonT(json['data']),
    );
  }
}
