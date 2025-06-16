import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigScreen extends StatefulWidget {
  const RemoteConfigScreen({super.key});

  @override
  State<RemoteConfigScreen> createState() => _RemoteConfigScreenState();
}

class _RemoteConfigScreenState extends State<RemoteConfigScreen> {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  Map<String, RemoteConfigValue> _configs = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRemoteConfig();
  }

  Future<void> _loadRemoteConfig() async {
    // It's good practice to fetch and activate to get the latest values.
    await _remoteConfig.fetchAndActivate();

    if (mounted) {
      setState(() {
        _configs = _remoteConfig.getAll();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remote Config')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _configs.isEmpty
              ? const Center(child: Text('No remote configs found.'))
              : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Key')),
                      DataColumn(label: Text('Value')),
                      DataColumn(label: Text('Source')),
                    ],
                    rows:
                        _configs.entries.toList().asMap().entries.map((
                          indexedEntry,
                        ) {
                          final index = indexedEntry.key;
                          final entry = indexedEntry.value;
                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>((
                              Set<MaterialState> states,
                            ) {
                              if (index.isEven) {
                                return Colors.grey.withOpacity(0.1);
                              }
                              return null; // Use default value for odd rows.
                            }),
                            cells: [
                              DataCell(Text(entry.key)),
                              DataCell(Text(entry.value.asString())),
                              DataCell(Text(entry.value.source.name)),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
    );
  }
}
