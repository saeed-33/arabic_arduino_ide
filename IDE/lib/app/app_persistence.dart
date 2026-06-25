import 'package:shared_preferences/shared_preferences.dart';

import 'package:arabic_arduino_ide/features/settings/domain/ide_settings.dart';

class AppPersistence {
  static const _keyArduinoCliPath = 'arduinoCliPath';
  static const _keyDefaultBoard = 'defaultBoard';
  static const _keySerialPort = 'serialPort';
  static const _keyLibrariesServerUrl = 'librariesServerUrl';
  static const _keyRecentFiles = 'recentFiles';
  static const _keyLastOpenedFilePath = 'lastOpenedFilePath';
  static const _maxRecentFiles = 10;

  final SharedPreferences _preferences;

  AppPersistence._(this._preferences);

  static Future<AppPersistence> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    return AppPersistence._(preferences);
  }

  IdeSettings loadSettings() {
    return IdeSettings(
      arduinoCliPath: _preferences.getString(_keyArduinoCliPath) ?? '',
      defaultBoard:
          _preferences.getString(_keyDefaultBoard) ?? 'arduino:avr:uno',
      serialPort: _preferences.getString(_keySerialPort) ?? '',
      librariesServerUrl: _preferences.getString(_keyLibrariesServerUrl) ?? '',
    );
  }

  Future<void> saveSettings(IdeSettings settings) async {
    await _preferences.setString(_keyArduinoCliPath, settings.arduinoCliPath);
    await _preferences.setString(_keyDefaultBoard, settings.defaultBoard);
    await _preferences.setString(_keySerialPort, settings.serialPort);
    await _preferences.setString(
      _keyLibrariesServerUrl,
      settings.librariesServerUrl,
    );
  }

  List<String> loadRecentFiles() {
    return _preferences.getStringList(_keyRecentFiles) ?? <String>[];
  }

  Future<void> saveRecentFiles(List<String> paths) async {
    final uniqueFiles = <String>[];
    for (final path in paths) {
      if (!uniqueFiles.contains(path)) {
        uniqueFiles.add(path);
      }
    }
    final trimmed = uniqueFiles.take(_maxRecentFiles).toList();
    await _preferences.setStringList(_keyRecentFiles, trimmed);
  }

  String? loadLastOpenedFilePath() {
    return _preferences.getString(_keyLastOpenedFilePath);
  }

  Future<void> saveLastOpenedFilePath(String? path) async {
    if (path == null || path.isEmpty) {
      await _preferences.remove(_keyLastOpenedFilePath);
      return;
    }
    await _preferences.setString(_keyLastOpenedFilePath, path);
  }

  Future<void> addRecentFile(String path) async {
    final current = loadRecentFiles();
    final updated = List<String>.from(current)..remove(path);
    updated.insert(0, path);
    await saveRecentFiles(updated);
  }
}
