import 'dart:io';

import 'package:flutter/material.dart';
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
            decoration: const InputDecoration(hintText: "Enter file name"),
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
            leading: Icon(
              entity is File ? Icons.insert_drive_file : Icons.folder,
            ),
            title: Text(entity.path.split('/').last),
            subtitle: Text(entity.path),
            onTap: () {
              if (entity is Directory) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FilesScreen(directory: entity),
                  ),
                );
              }
            },
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
