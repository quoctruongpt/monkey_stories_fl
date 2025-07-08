// Dart imports:
import 'dart:io';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FilesScreen extends StatefulWidget {
  final Directory? directory;
  const FilesScreen({super.key, this.directory});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  List<FileSystemEntity> _files = [];
  late Directory _currentDir;
  final TextEditingController _fileNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    if (widget.directory == null) {
      _currentDir = await getApplicationDocumentsDirectory();
    } else {
      _currentDir = widget.directory!;
    }

    setState(() {
      _files = _currentDir.listSync();
    });
  }

  Future<void> _createFile() async {
    if (_fileNameController.text.isNotEmpty) {
      final newFile = File('${_currentDir.path}/${_fileNameController.text}');
      if (!await newFile.exists()) {
        await newFile.create();
        _fileNameController.clear();
        _loadFiles();
      }
    }
  }

  Future<void> _showCreateFileDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a new file'),
          content: TextField(
            controller: _fileNameController,
            decoration: const InputDecoration(hintText: 'Enter file name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                _createFile();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  Future<void> _showDetails(FileSystemEntity entity) async {
    final stat = await entity.stat();
    final type = entity is File ? 'File' : 'Directory';
    final size = stat.size;
    final modified = stat.modified;

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text('Details', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.title),
                title: const Text('Name'),
                subtitle: Text(entity.path.split('/').last),
              ),
              ListTile(
                leading: const Icon(Icons.folder_open),
                title: const Text('Path'),
                subtitle: Text(entity.path),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Type'),
                subtitle: Text(type),
              ),
              if (entity is File)
                ListTile(
                  leading: const Icon(Icons.sd_storage),
                  title: const Text('Size'),
                  subtitle: Text(_formatBytes(size)),
                ),
              ListTile(
                leading: const Icon(Icons.more_time),
                title: const Text('Last Modified'),
                subtitle: Text(modified.toLocal().toString()),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getIconForEntity(FileSystemEntity entity) {
    if (entity is Directory) {
      return const Icon(Icons.folder, color: Colors.orange);
    }

    final path = entity.path;
    if (!path.contains('.')) {
      return const Icon(Icons.insert_drive_file, color: Colors.grey);
    }

    final extension = path.substring(path.lastIndexOf('.')).toLowerCase();
    IconData iconData;
    Color iconColor = Colors.grey;

    switch (extension) {
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.bmp':
      case '.heic':
        iconData = Icons.image;
        iconColor = Colors.redAccent;
        break;
      case '.pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.blueAccent;
        break;
      case '.doc':
      case '.docx':
      case '.txt':
        iconData = Icons.description;
        iconColor = Colors.blue;
        break;
      case '.xls':
      case '.xlsx':
        iconData = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case '.ppt':
      case '.pptx':
        iconData = Icons.slideshow;
        iconColor = Colors.orangeAccent;
        break;
      case '.mp3':
      case '.wav':
      case '.aac':
        iconData = Icons.audiotrack;
        iconColor = Colors.purpleAccent;
        break;
      case '.mp4':
      case '.mov':
      case '.avi':
        iconData = Icons.videocam;
        iconColor = Colors.deepOrange;
        break;
      case '.zip':
      case '.rar':
      case '.7z':
        iconData = Icons.archive;
        iconColor = Colors.brown;
        break;
      case '.dart':
      case '.js':
      case '.json':
      case '.html':
      case '.css':
        iconData = Icons.code;
        iconColor = Colors.teal;
        break;
      default:
        iconData = Icons.insert_drive_file;
    }
    return Icon(iconData, color: iconColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.directory?.path.split('/').last ?? 'File Browser'),
      ),
      body: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          final entity = _files[index];
          return ListTile(
            leading: _getIconForEntity(entity),
            title: Text(entity.path.split('/').last),
            subtitle: Text(entity.path),
            onTap: () {
              if (entity is Directory) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FilesScreen(directory: entity),
                  ),
                );
              } else if (entity is File) {
                OpenFile.open(entity.path);
              }
            },
            trailing: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showDetails(entity),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateFileDialog,
        tooltip: 'New File',
        child: const Icon(Icons.add),
      ),
    );
  }
}
