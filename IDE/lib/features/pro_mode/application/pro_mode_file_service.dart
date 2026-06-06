import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';

class ProModeFileService {
  static const _arabicArduinoFileType = XTypeGroup(
    label: 'Arabic Arduino files',
    extensions: ['arabic', 'ino', 'txt'],
  );

  Future<OpenedFile?> openCodeFile() async {
    try {
      final file = await openFile(acceptedTypeGroups: [_arabicArduinoFileType]);
      if (file == null) {
        return null;
      }

      return OpenedFile(path: file.path, content: await file.readAsString());
    } on MissingPluginException catch (error) {
      throw FileDialogUnavailableException(error);
    }
  }

  Future<String?> saveCodeFile({
    required String content,
    required String? currentPath,
  }) async {
    try {
      final path = currentPath ?? await _pickSavePath();
      if (path == null) {
        return null;
      }

      await File(path).writeAsString(content);
      return path;
    } on MissingPluginException catch (error) {
      throw FileDialogUnavailableException(error);
    }
  }

  String displayNameForPath(String path) {
    return path.split(RegExp(r'[\\/]')).last;
  }

  Future<String?> _pickSavePath() async {
    final saveLocation = await getSaveLocation(
      acceptedTypeGroups: [_arabicArduinoFileType],
      suggestedName: 'برنامج_عربي.arabic',
    );

    return saveLocation?.path;
  }
}

class OpenedFile {
  const OpenedFile({required this.path, required this.content});

  final String path;
  final String content;
}

class FileDialogUnavailableException implements Exception {
  const FileDialogUnavailableException(this.cause);

  final MissingPluginException cause;
}
