enum ApiStatus {
  success('success'),
  fail('fail');

  final String value;
  const ApiStatus(this.value);

  /// Parses the string status from the API into an [ApiStatus] enum value.
  /// Defaults to [ApiStatus.fail] if the input string is null or does not match known statuses.
  factory ApiStatus.fromString(String? apiValue) {
    // Accept nullable string
    if (apiValue == null) {
      // Log or handle null status string as needed
      // print('Warning: API status string is null, defaulting to fail.');
      return ApiStatus.fail;
    }
    for (var status in values) {
      if (status.value == apiValue) {
        return status;
      }
    }
    // Log or handle unknown status string as needed
    // print('Warning: Unknown API status string: "$apiValue", defaulting to fail.');
    return ApiStatus.fail; // Default to fail for unknown/invalid status
  }
}

class ApiResponse<T> {
  final ApiStatus status; // Changed to enum
  final String message;
  final int code;
  final T data; // Data field remains generic

  ApiResponse({
    required this.status,
    required this.message,
    required this.code,
    required this.data,
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
