import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

abstract class DownloadRemoteDataSource {
  Future<String> downloadImage(String url, String fileName);
}

class DownloadRemoteDataSourceImpl implements DownloadRemoteDataSource {
  final Dio dio;

  DownloadRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> downloadImage(String url, String fileName) async {
    try {
      if (url.isEmpty) {
        return '';
      }

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      if (await file.exists()) {
        return filePath; // Return path if file already exists
      }

      final response = await dio.download(url, filePath);

      if (response.statusCode == 200) {
        return filePath;
      }
      return '';
    } catch (e) {
      return '';
    }
  }
}
