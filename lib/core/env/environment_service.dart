import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class EnvironmentService {
  static const String _envKey = 'env';
  static const String _defaultEnv = 'prod';

  // Danh sách các môi trường hỗ trợ
  static const List<String> availableEnvironments = ['dev', 'prod'];

  // Thay đổi late final thành late để có thể gán lại giá trị
  late String currentEnvironment;

  /// Singleton instance
  static final EnvironmentService _instance = EnvironmentService._internal();

  /// Factory constructor để trả về singleton instance
  factory EnvironmentService() => _instance;

  /// Private constructor
  EnvironmentService._internal();

  /// Khởi tạo service và load environment
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    currentEnvironment = prefs.getString(_envKey) ?? _defaultEnv;
    await dotenv.load(fileName: '.env.$currentEnvironment');
  }

  /// Thay đổi môi trường và reload ứng dụng
  Future<void> changeEnvironment(String env) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setString(_envKey, env);
    currentEnvironment = env;
    await dotenv.load(fileName: '.env.$env');
  }

  /// Hiển thị dialog chọn môi trường
  Future<void> showEnvironmentSelector(BuildContext context) async {
    // Kiểm tra xem context có chứa Navigator không

    return _showEnvironmentSelectorDialog(context, false);
  }

  /// Hàm nội bộ để hiển thị dialog
  Future<void> _showEnvironmentSelectorDialog(
    BuildContext context,
    bool useRootNavigator,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        // Sử dụng dialogContext thay vì context
        return AlertDialog(
          title: const Text('Chọn môi trường'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  availableEnvironments.map((env) {
                    final isSelected = env == currentEnvironment;
                    return ListTile(
                      title: Text(
                        env.toUpperCase(),
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      leading:
                          isSelected
                              ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                              : const Icon(Icons.circle_outlined),
                      onTap: () async {
                        if (env != currentEnvironment) {
                          Navigator.of(
                            dialogContext,
                          ).pop(); // Sử dụng dialogContext

                          // Hiển thị loading dialog
                          _showLoadingDialog(context, useRootNavigator);

                          // Đổi môi trường
                          await changeEnvironment(env);

                          // Đóng loading dialog
                          if (useRootNavigator) {
                            if (context.mounted &&
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).canPop()) {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          } else {
                            if (context.mounted &&
                                Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          }

                          // Hiển thị thông báo cần restart
                          if (context.mounted) {
                            _showRestartDialog(context, useRootNavigator);
                          }
                        } else {
                          Navigator.of(
                            dialogContext,
                          ).pop(); // Sử dụng dialogContext
                        }
                      },
                    );
                  }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Sử dụng dialogContext
              },
            ),
          ],
        );
      },
    );
  }

  /// Hiển thị loading dialog khi đang thay đổi môi trường
  void _showLoadingDialog(BuildContext context, bool useRootNavigator) {
    showDialog(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Đang thay đổi môi trường...'),
            ],
          ),
        );
      },
    );
  }

  /// Hiển thị thông báo cần restart app
  void _showRestartDialog(BuildContext context, bool useRootNavigator) {
    showDialog(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Thay đổi môi trường thành công'),
          content: const Text(
            'Bạn cần khởi động lại ứng dụng để áp dụng thay đổi.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }

  /// Lấy giá trị từ file env dựa vào key
  String get(String key) {
    return dotenv.env[key] ?? '';
  }

  /// Lấy giá trị từ file env dựa vào key với giá trị mặc định
  String getOrDefault(String key, String defaultValue) {
    return dotenv.env[key] ?? defaultValue;
  }

  /// Kiểm tra có phải môi trường dev không
  bool get isDevelopment => currentEnvironment == 'dev';

  /// Kiểm tra có phải môi trường staging không
  bool get isStaging => currentEnvironment == 'staging';

  /// Kiểm tra có phải môi trường production không
  bool get isProduction => currentEnvironment == 'prod';
}
