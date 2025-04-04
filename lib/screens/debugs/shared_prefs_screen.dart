import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesScreen extends StatefulWidget {
  const SharedPreferencesScreen({super.key});

  @override
  State<SharedPreferencesScreen> createState() =>
      _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  final Map<String, dynamic> _preferences = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final prefsMap = <String, dynamic>{};

    for (final key in keys) {
      if (prefs.getString(key) != null) {
        prefsMap[key] = prefs.getString(key);
      } else if (prefs.getBool(key) != null) {
        prefsMap[key] = prefs.getBool(key);
      } else if (prefs.getInt(key) != null) {
        prefsMap[key] = prefs.getInt(key);
      } else if (prefs.getDouble(key) != null) {
        prefsMap[key] = prefs.getDouble(key);
      } else if (prefs.getStringList(key) != null) {
        prefsMap[key] = prefs.getStringList(key);
      }
    }

    setState(() {
      _preferences.addAll(prefsMap);
      _isLoading = false;
    });
  }

  Future<void> _deletePreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    setState(() {
      _preferences.remove(key);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã xóa "$key"')));
  }

  Future<void> _clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _preferences.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã xóa tất cả dữ liệu')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _preferences.clear();
              });
              _loadPreferences();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed:
                _preferences.isEmpty
                    ? null
                    : () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Xóa tất cả'),
                              content: const Text(
                                'Bạn có chắc chắn muốn xóa tất cả shared preferences?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _clearAllPreferences();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Xóa tất cả'),
                                ),
                              ],
                            ),
                      );
                    },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _preferences.isEmpty
              ? const Center(child: Text('Không có dữ liệu'))
              : ListView.separated(
                itemCount: _preferences.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final key = _preferences.keys.elementAt(index);
                  final value = _preferences[key];
                  return Dismissible(
                    key: Key(key),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _deletePreference(key),
                    child: ListTile(
                      title: Text(key),
                      subtitle: Text(
                        value.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.content_copy),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã sao chép: $value')),
                          );
                        },
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(key),
                                content: SingleChildScrollView(
                                  child: Text(value.toString()),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text('Đóng'),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
