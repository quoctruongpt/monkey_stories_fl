class HttpLog {
  final String url;
  final String method;
  final int statusCode;
  final Map<String, dynamic> requestHeaders;
  final dynamic requestBody;
  final Map<String, dynamic> responseHeaders;
  final dynamic responseBody;
  final DateTime timestamp;
  final Duration latency;

  HttpLog({
    required this.url,
    required this.method,
    required this.statusCode,
    required this.requestHeaders,
    this.requestBody,
    required this.responseHeaders,
    this.responseBody,
    required this.timestamp,
    required this.latency,
  });
}
