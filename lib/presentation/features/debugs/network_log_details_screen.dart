import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'package:monkey_stories/presentation/features/debugs/http_log.dart';

// Note: The _HttpLog class is defined in network_logger_screen.dart
// For a real app, this should be in its own file.

class NetworkLogDetailsScreen extends StatelessWidget {
  final HttpLog log;

  const NetworkLogDetailsScreen({super.key, required this.log});

  String _generateCurlCommand(HttpLog log) {
    final buffer = StringBuffer();
    buffer.write('curl --request ${log.method.toUpperCase()}');
    buffer.write(" '${log.url}'");

    log.requestHeaders.forEach((key, value) {
      buffer.write(" --header '$key: $value'");
    });

    if (log.requestBody != null && log.requestBody!.isNotEmpty) {
      buffer.write(" --data-raw '${log.requestBody}'");
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Log Details'),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    final curlCommand = _generateCurlCommand(log);
                    Share.share(curlCommand);
                  },
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Request'),
              Tab(text: 'Response'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildRequestTab(),
            _buildResponseTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('URL', log.url),
          _buildDetailRow('Method', log.method),
          _buildDetailRow('Status Code', log.statusCode.toString()),
          _buildDetailRow('Timestamp', log.timestamp.toIso8601String()),
          _buildDetailRow('Latency', '${log.latency.inMilliseconds} ms'),
        ],
      ),
    );
  }

  Widget _buildRequestTab() {
    return _buildTabContent(
      headers: log.requestHeaders,
      body: log.requestBody,
      title: 'Request',
    );
  }

  Widget _buildResponseTab() {
    return _buildTabContent(
      headers: log.responseHeaders,
      body: log.responseBody,
      title: 'Response',
    );
  }

  Widget _buildTabContent({
    required Map<String, dynamic> headers,
    required dynamic body,
    required String title,
  }) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('Headers'),
        const SizedBox(height: 8),
        _buildHeaders(headers),
        const SizedBox(height: 24),
        _buildSectionTitle('Body'),
        const SizedBox(height: 8),
        _buildBody(body),
      ],
    );
  }

  Widget _buildHeaders(Map<String, dynamic> headers) {
    if (headers.isEmpty) {
      return const Text('No headers');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          headers.entries
              .map(
                (entry) => _buildDetailRow(entry.key, entry.value.toString()),
              )
              .toList(),
    );
  }

  Widget _buildBody(dynamic body) {
    if (body == null) {
      return const Text('Empty body');
    }

    const jsonEncoder = JsonEncoder.withIndent('  ');
    final String formattedBody;
    if (body is Map || body is List) {
      formattedBody = jsonEncoder.convert(body);
    } else {
      formattedBody = body.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: formattedBody));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey.shade200,
          child: SelectableText(formattedBody),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDetailRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$key:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}
