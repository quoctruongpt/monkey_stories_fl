import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:monkey_stories/presentation/bloc/debug/debug_cubit.dart';
import 'package:monkey_stories/presentation/features/debugs/http_log.dart';
import 'package:monkey_stories/presentation/features/debugs/network_log_details_screen.dart';

class NetworkLoggerScreen extends StatelessWidget {
  const NetworkLoggerScreen({super.key});

  Color _getStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return Colors.green;
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.orange;
    } else if (statusCode >= 500) {
      return Colors.red;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Logger'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => context.read<DebugCubit>().clearLogs(),
          ),
        ],
      ),
      body: BlocBuilder<DebugCubit, DebugState>(
        builder: (context, state) {
          final reversedLogs = state.httpLogs?.reversed.toList();

          if (reversedLogs == null || reversedLogs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Anh chị ơi chưa có log nào nè. Đừng quên bật tính năng logger 📝 hoặc liên hệ bạn nào đẹp trai nhất team Kỹ thuật 🙋‍♂️ để được hướng dẫn nhé ạ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: reversedLogs.length,
            itemBuilder: (context, index) {
              final log = reversedLogs[index];

              final path = Uri.tryParse(log.url)?.path ?? log.url;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(log.statusCode),
                    child: Text(
                      log.statusCode.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    '${log.method} $path',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${DateFormat.Hms().format(log.timestamp)} - ${log.latency.inMilliseconds}ms',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NetworkLogDetailsScreen(log: log),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
