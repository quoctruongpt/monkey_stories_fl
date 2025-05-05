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
